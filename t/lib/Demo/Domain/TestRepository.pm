package Demo::Domain::TestRepository;
use Moose;
use namespace::autoclean;

extends 'DDD::Repository';

__PACKAGE__->meta->make_immutable;
1;
