package DDD::Role::Domain;
use Moose::Role;
use MooseX::Storage;

has domain => (
    traits   => [ 'DoNotSerialize' ],
    is       => 'ro',
    isa      => 'DDD::Base::Domain',
    weak_ref => 1,
    handles  => [ 
        'log_debug'
    ],
);

1;
