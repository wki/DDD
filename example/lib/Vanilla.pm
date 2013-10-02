package Vanilla;
use DDD::Domain;

# ABSTRACT: a simple example domain

has schema => (
    is  => 'ro',
    isa => 'DBIx::Class::Schema',
);

has log => (
    is => 'ro',
    isa => 'Object',
);

# a request-scoped attr. Caution: 'default' is injected automatically
has user => (
    is        => 'ro',
    isa       => 'Maybe[Str]',
    lifecycle => '+DDD::LifeCycle::Request', # or 'Request' if OX is installed
);

service some_service => (
    isa          => 'SomeService',
    dependencies => {
        schema => dep('/schema'),
    },
);

subdomain sales => (
    isa => 'Sales',
);

# factory foo_generator => ( isa => 'FooGenerator' );

# repository all_foo => ( isa => 'AllFoo' );

1;
