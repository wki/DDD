package My::Aggregate;
use 5.016;
use Moose;
use namespace::autoclean;

extends 'DDD::Aggregate';
with 'Role::Jabber',
     'Role::Security',
     'Role::Log';

sub resultset_name { 'FooBar' }


__PACKAGE__->meta->make_immutable;
1;
