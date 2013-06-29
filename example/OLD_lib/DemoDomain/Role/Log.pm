package Role::Log;
use Moose::Role;

has log => (
    is       => 'ro',
    isa      => 'Object',
    required => 1,
);

1;
