package DDD::Role::Domain;
use Moose::Role;
#use Bread::Board::Declare; # why did I think, this is needed?

has domain => (
    is       => 'ro',
    isa      => 'Object',
    required => 1,
);

1;
