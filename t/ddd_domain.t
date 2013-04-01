use strict;
use warnings;
use Test::More;

use ok 'DDD::Domain';
use ok 'DDD::Aggregate';
use ok 'DDD::Service';

{
    # --------------------------------- our "Infrastructure"
    package My::Schema;
    use Moose;
    # primitive DBIC Mock
    # sub resultset { bless {}, 'DBIx::Class::ResultSet' }
    
    package My::Storage;
    use Moose;
    
    # --------------------------------- our "Domain"
    package Some::Domain::Thing;
    use Moose;
    extends 'DDD::Aggregate';
    sub _resultset_name { 'Doom' }
    sub __is_initialized__ {} # fake BUILD method
    has schema => (is => 'ro', isa => 'Object');
    has foo    => (is => 'ro', isa => 'Str', predicate => 'has_foo');
    
    package My::Domain::DoIt;
    use Moose;
    extends 'DDD::Service';
    has schema  => (is => 'ro', isa => 'Object');
    has storage => (is => 'ro', isa => 'Object');
    
    package My::Domain;
    use DDD::Domain;
    has schema  => (is => 'ro', isa => 'Object');
    has storage => (is => 'ro', isa => 'Object');
    
    service do_it => (
        isa          => 'DoIt',
        dependencies => [ 'schema', 'storage' ],
    );

    aggregate thing => (
        isa          => '+Some::Domain::Thing',
        dependencies => [ 'schema' ],
        parameters   => {
            foo => { isa => 'Int', optional => 1 },
        },
    );
}

my $schema  = My::Schema->new;
my $storage = My::Storage->new;
my $domain  = My::Domain->new(schema => $schema, storage => $storage);

is $domain->schema,  $schema,  'schema can get retrieved';
is $domain->storage, $storage, 'storage can get retrieved';

isa_ok $domain->do_it, 'My::Domain::DoIt';
is $domain->do_it, $domain->do_it, 'do_it service always returns the same object';
is $domain->do_it->domain,  $domain,  'domain can get retrieved';
is $domain->do_it->schema,  $schema,  'do_it knows schema';
is $domain->do_it->storage, $storage, 'do_it knows storage';

isa_ok $domain->thing, 'Some::Domain::Thing';
isnt $domain->thing, $domain->thing, 'aggregate always returns a new object';
is $domain->thing->domain, $domain, 'domain is present in thing';
ok !$domain->thing->has_foo, 'missing foo attribute is missing in thing';
ok $domain->thing(foo => 42)->has_foo, 'given foo attribute is present in thing';
is $domain->thing(foo => 42)->foo, 42, 'given foo attribute is correct in thing';

TODO: {
    todo_skip 'more constructor things in planning', 2;
    
    is $domain->thing(id => 42)->id, 42, 'given id attribute is correct in thing';
    is $domain->thing(42)->id, 42,       'a scalar value is used as ID';
};


done_testing;
