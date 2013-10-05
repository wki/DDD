use strict;
use warnings;
use Path::Class;
use JSON;
use Test::More;

use ok 'DDD::Base::Object';

# sample class inheriting base
{
    package X;
    use Moose;
    our $VERSION = 23;
    
    extends 'DDD::Base::Object';
    
    has foo => (is => 'rw', isa => 'Str');
}

note 'serialization';
{
    my $x1 = X->new(foo => 'x42');
    
    is_deeply $x1->pack(),
        { __CLASS__ => 'X-23', foo => 'x42' },
        'pack';
    
    my $x2 = X->unpack( { __CLASS__ => 'X', foo => 'bar' } );
    isa_ok $x2, 'X';
    is $x2->foo, 'bar', 'unpack: foo is bar';
}

note 'store and load';
{
    my $x1 = X->new(foo => 'baz');
    my $dir = Path::Class::tempdir(CLEANUP => 1);
    my $file = $dir->file('bar.json');
    
    ok !-f $file, 'json file not yet present';
    $x1->store($file->stringify);
    ok -f $file, 'json file created';
    
    is_deeply decode_json(scalar $file->slurp),
        { __CLASS__ => 'X-23', foo => 'baz' },
        'JSON file contains serialized object';
    
    my $x2 = X->load($file->stringify);
    isa_ok $x2, 'X';
    is $x2->foo, 'baz', 'unpack: foo is baz';
}

done_testing;
