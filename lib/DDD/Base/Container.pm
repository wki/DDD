package DDD::Base::Container;
use Moose;
use Bread::Board::Declare;
use Scalar::Util 'refaddr';
use namespace::autoclean;

# use Bread::Board::Declare;
# can not use Role::Domain here because we are a Bread::Board container
# and 'has' behaves differently here.
has domain => (
    is         => 'ro',
    isa        => 'DDD::Base::Container',
    block      => sub {
        my $my_addr   = refaddr $_[1];
        my $root_addr = refaddr $_[0]->get_root_container;
        
        return $my_addr == $root_addr
            ? $_[1]
            : $_[0]->get_root_container;
    },
    weak_ref   => 1,
);

__PACKAGE__->meta->make_immutable;
1;
