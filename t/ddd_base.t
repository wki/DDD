use strict;
use warnings;
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

done_testing;
