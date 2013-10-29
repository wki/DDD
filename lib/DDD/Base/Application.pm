package DDD::Base::Application;
use Moose;
use DDD::TransactionManager;

extends 'DDD::Base::Container';
with 'DDD::Role::Domain';

has transaction_manager => (
    is         => 'ro',
    isa        => 'DDD::TransactionManager',
    lazy_build => 1,
);

sub _build_transaction_manager  {
    DDD::TransactionManager->new
}

__PACKAGE__->meta->make_immutable;
1;
