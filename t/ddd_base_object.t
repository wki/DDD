use strict;
use warnings;
use DateTime;
use Path::Class;
use JSON;
use Test::More;
use Test::MockDateTime;

use ok 'DDD::Base::Object';

# sample class inheriting base
{
    package X;
    use Moose;
    our $VERSION = 23;
    
    extends 'DDD::Base::Object';
    
    has foo => (is => 'rw', isa => 'Str');
    has bar => (is => 'rw', isa => 'DateTime');
}

note 'serialization';
{
    my $x1 = X->new(foo => 'x42', bar => DateTime->from_epoch(epoch => 1381166265));
    
    is_deeply $x1->pack(),
        { __CLASS__ => 'X-23', foo => 'x42', bar => 1381166265 },
        'pack';
    
    my $x2 = X->unpack( { __CLASS__ => 'X', foo => 'bar', bar => 1381166265 } );
    isa_ok $x2, 'X';
    is $x2->foo, 'bar', 'unpack: foo is bar';
    is $x2->bar->epoch, 1381166265, 'unpack: bar is back';
    
    ### TODO: add tests for Path::Class::  File / Dir
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

note 'now';
on '2012-12-24 17:23:45' => sub {
    my $x = X->new;
    
    is $x->_now->ymd, '2012-12-24', '_now date';
    is $x->_now->hms, '17:23:45',   '_now time';
};

done_testing;
