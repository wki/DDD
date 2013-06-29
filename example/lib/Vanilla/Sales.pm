package Vanilla::Sales;
use Moose;
use Bread::Board::Declare;
use namespace::autoclean;

has sell_service => (
    is           => 'ro',
    isa          => 'Vanilla::Sales::SellService',
    dependencies => {
        domain => dep('/domain'),
        schema => dep('/schema'),
    },
);

__PACKAGE__->meta->make_immutable;
1;
