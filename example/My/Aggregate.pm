package My::Aggregate;
use 5.016;
use Moose;
use namespace::autoclean;

extends 'DDD::Aggregate';
with 'Role::Jabber';

__PACKAGE__->meta->make_immutable;
1;
