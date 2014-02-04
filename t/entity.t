use Test::Most;

use ok 'DDD::Entity';

{
    package E;
    our $VERSION = '0.42';
    use Moose;
    extends 'DDD::Entity';
    has bar => (is => 'ro', isa => 'Str');
    
    package F;
    use Moose;
    has id  => (is => 'ro', isa => 'Str');
    has bar => (is => 'ro', isa => 'Str');
}

note 'failing construction';
{
    # we allow constructing w/o entity
    # dies_ok { DDD::Entity->new }
    #     'constructing a base entity w/o id fails';
    # 
    # dies_ok { E->new }
    #     'constructing an entity w/o id fails';

    dies_ok { E->new(id => undef) }
        'constructing an entity w/ undef id fails';
}

note 'no id';
{
    my $e = E->new;
    
    ok !$e->has_id, 'no id';
    
    $e->_id(4711);
    ok $e->has_id, 'has id';
    is $e->id, 4711, 'id';
}

note 'compare';
{
    my $nul= E->new;
    my $e1 = E->new(id => 42, bar => 'xxx');
    my $e2 = E->new(id => 42, bar => 'different');
    my $e3 = E->new(id => 43, bar => 'xxx');
    my $f  = F->new(id => 42, bar => 'xxx');
    
    ok !$nul->is_equal($e1), 'w/o id is not equal e1';
    ok !$e1->is_equal($nul), 'e1 is not equal w/o id';
    
    ok $e1->is_equal($e2), 'e1 and e2 have same id';
    ok $e2->is_equal($e1), 'e2 and e1 have same id';

    ok !$e1->is_equal($e3), 'e1 and e3 have different id';
    ok !$e3->is_equal($e1), 'e3 and e1 have different id';
    
    ok !$e1->is_equal($f), 'e1 and f are different class';
}

note 'serialization';
{
    my $e1 = E->new(id => 42, bar => 'baz');
    
    is_deeply $e1->pack,
        { __CLASS__ => 'E-0.42', id => 42, bar => 'baz' },
        'serialization';
    
    my $e2 = E->unpack({ __CLASS__ => 'E-0.42', id => 42, bar => 'baz' });
    
    isa_ok $e2, 'E';
    is $e2->id, 42, 'id';
    is $e2->bar, 'baz', 'bar';
    
    isnt $e1, $e2, 'separate instances';
    
    ok $e1->is_equal($e2), 'equal';
}

done_testing;
