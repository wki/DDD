package DDD::Role::Domain;
use Carp;
use Moose::Role;
use MooseX::Storage;

has domain => (
    traits     => [ 'DoNotSerialize' ],
    is         => 'ro',
    isa        => 'Object', # 'DDD::Base::Domain' ?
    weak_ref   => 1,
    lazy_build => 1,
    handles    => [ 
        'log_debug'
    ],
);

# assume that all classes inside a domain reside in a child-namespace
# of the domain. Crawl up until we reached the domain.
sub _build_domain {
    my $self = shift;
    
    my @package_parts = split '::', ref $self;
    
    while (@package_parts) {
        my $package = join '::', @package_parts;
        
        return $package->instance
            if $package->isa('DDD::Base::Domain');
        
        pop @package_parts;
    }
    
    croak 'cannot guess domain package for: ' . ref $self;
}

1;
