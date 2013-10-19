package DDD::Meta::Trait::Class::Domain;
use Moose::Role;

Moose::Util::meta_class_alias('HasDomain');

has domain => (
    is  => 'rw',
    isa => 'Object',
);

1;
