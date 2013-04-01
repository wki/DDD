package DDD::Role::Domain;
use Moose::Role;
use Bread::Board::Declare;

has domain => (
    is       => 'ro',
    isa      => 'Object',
    required => 1,
);

1;
