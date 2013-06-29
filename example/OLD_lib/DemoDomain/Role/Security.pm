package Role::Security;
use Moose::Role;

has security => (
    is       => 'ro',
    isa      => 'Object',
    required => 1,
);

1;

