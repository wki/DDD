package My::SecurityService;
use 5.016;
use Moose;
use Path::Class;
use namespace::autoclean;

extends 'DDD::Service';
with 'DDD::Role::DBIC::Schema';

__PACKAGE__->meta->make_immutable;
1;
