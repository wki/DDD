package DDD::Base::Container;
use Moose;
use Bread::Board::Declare;
# use namespace::autoclean;

# use Bread::Board::Declare;
# can not use Role::Domain here because we are a Bread::Board container
# and 'has' behaves differently here.
has domain => (
    is         => 'ro',
    isa        => 'DDD::Base::Container',
    block    => sub { $_[1] },
    weak_ref   => 1,
    # lazy_build => 1,
);

# sub _build_domain { $_[0] }

__PACKAGE__->meta->make_immutable;
1;
