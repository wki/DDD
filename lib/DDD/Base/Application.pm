package DDD::Base::Application;
use Moose;

extends 'DDD::Base::Container';
with 'DDD::Role::Domain';

__PACKAGE__->meta->make_immutable;
1;
