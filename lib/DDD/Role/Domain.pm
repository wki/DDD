package DDD::Role::Domain;
use Moose::Role;

has domain => (
    is       => 'ro',
    isa      => 'Object',
    required => 1,
);

1;
