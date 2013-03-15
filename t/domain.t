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
    
    package My::Storage;
    use Moose;
    
    # --------------------------------- our "Domain"
    package My::Domain::Thing;
    use Moose;
    extends 'DDD::Aggregate';
    has schema => (is => 'ro', isa => 'Object');
    
    package My::Domain::DoIt;
    use Moose;
    extends 'DDD::Service';
    has schema => (is => 'ro', isa => 'Object');
    has do_it  => (is => 'ro', isa => 'Object');
    
    package My::Domain;
    use DDD::Domain;
    has schema  => (is => 'ro', isa => 'Object');
    has storage => (is => 'ro', isa => 'Object');

    service do_it => (
        isa          => 'DoIt',
        dependencies => [ 'schema', 'storage' ],
    );

    aggregate orderlist => (
        isa          => '+My::Domain::Thing',
        dependencies => [ 'schema' ],
    );
}

my $schema  = My::Schema->new;
my $storage = My::Storage->new;
my $domain  = My::Domain->new(schema => $schema, storage => $storage);

is $domain->schema,  $schema,  'schema can get retrieved';
is $domain->storage, $storage, 'storage can get retrieved';

my $do_it = $schema->do_it

done_testing;
