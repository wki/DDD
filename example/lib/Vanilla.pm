# ABSTRACT: a simple example domain

package Vanilla;
use DDD::Domain;
use Vanilla::Sales; # Subdomain

# auto-generated: 'domain' attribute

# a regular Moose attribute
has schema => (
    is  => 'ro',
    isa => 'DBIx::Class::Schema',
);

# a request-scoped attr
has user => (
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
    isa => 'Vanilla::Sales', # FIXME: can we auto-require?
);

# factory foo_generator => ( isa => 'Vanilla::FooGenerator' );

# repository foo_storage => ( isa => 'Vanilla::FooStorage' );

1;
