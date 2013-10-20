use Test::Most;

use ok 'DDD::Value';

{
    package V;
    use Moose;
    extends 'DDD::Value';
    
    has a1 => (is => 'ro', isa => 'Str');
    has a2 => (is => 'ro', isa => 'Str');
}

{
    package W;
    use Moose;
    extends 'DDD::Value';
}

note 'equality check';
{
    my $v1 = V->new(a1 => 'abc', a2 => 'def');
    my $v2 = V->new(a1 => 'abc', a2 => 'def');
    my $v3 = V->new(a1 => 'abc', a2 => 'xxx');
    my $w  = W->new;
    
    ok $v1->is_equal($v2), 'v1 eq v2';
    ok $v2->is_equal($v1), 'v2 eq v1';
    
    ok !$v1->is_equal($v3), 'v1 ne v3';
    
    ok !$v1->is_equal($w),  'v1 ne w';
}

done_testing;
