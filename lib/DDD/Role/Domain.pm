package DDD::Role::Domain;
use Moose::Role;

has domain => (
    traits   => [ 'DoNotSerialize' ],
    is       => 'ro',
    isa      => 'Object',
    required => 1,
);

1;
