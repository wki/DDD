package Demo::Domain::TestFactory;
use Moose;
use namespace::autoclean;

extends 'DDD::Factory';

__PACKAGE__->meta->make_immutable;
1;
