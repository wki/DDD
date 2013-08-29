# ABSTRACT: a simple domain using Bread::Board::Declare only

package Vanilla;
use DDD::Domain;
use Vanilla::Sales;

# auto-generated: 'domain' attribute

# a regular Moose attribute
attr schema => (
    is  => 'ro',
    isa => 'DBIx::Class::Schema',
);

# a request-scoped attr
attr user => (
    is        => 'ro',
    isa       => 'Object',
    lifecycle => '+DDD::LifeCycle::Request', # or 'Request' if OX is installed
);


# TODO: has storage

service some_service => (
    isa          => 'Vanilla::SomeService',
    dependencies => {
        schema => dep('/schema'),
    },
);

subdomain sales => (
    isa => 'Vanilla::Sales',
);

# factory foo_generator => ( isa => 'Vanilla::FooGenerator' );

# repository foo_storage => ( isa => 'Vanilla::FooStorage' );

__PACKAGE__->meta->make_immutable;
1;
