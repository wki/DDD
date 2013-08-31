package DDD::Base::Service;
use DDD::Meta::Class::Trait::Subscribe; # FIXME: can we avoid this line?
use Moose -traits => 'Subscribe';
use namespace::autoclean;

extends 'DDD::Base::Object';
with 'DDD::Role::Domain';

1;
