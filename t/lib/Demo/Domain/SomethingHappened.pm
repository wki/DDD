package Demo::Domain::SomethingHappened;
use Moose;
use namespace::autoclean;

extends 'DDD::Event';

has thing => (
    is      => 'ro',
    isa     => 'Str',
    default => '',
);

__PACKAGE__->meta->make_immutable;
1;
