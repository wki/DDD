package My::Aggregate;
use 5.016;
use Moose;
use namespace::autoclean;

extends 'DDD::Aggregate';
with 'Role::Jabber';

has schema => (
    is  => 'ro',
    isa => 'DBIx::Class::Schema',
);

__PACKAGE__->meta->make_immutable;
1;
