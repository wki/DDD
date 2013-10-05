use strict;
use warnings;
use Test::More;

use ok 'DDD::Value';

{
    package V;
    use Moose;
    extends 'DDD::Value';
    
    has a1 => (is => 'ro', isa => 'Str');
    has a2 => (is => 'ro', isa => 'Str');
}

note 'equality check';
{
    my $v1 = V->new(a1 => 'abc', a2 => 'def');
    my $v2 = V->new(a1 => 'abc', a2 => 'def');
    my $v3 = V->new(a1 => 'abc', a2 => 'xxx');
    
    ok $v1->is_equal($v2), 'v1 eq v2';
    ok $v2->is_equal($v1), 'v2 eq v1';
    
    ok !$v1->is_equal($v3), 'v1 ne v3';
}

done_testing;
