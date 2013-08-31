package Vanilla::Sales;
use DDD::Domain;

has sell_service => (
    is           => 'ro',
    isa          => 'Vanilla::Sales::SellService',
    dependencies => {
        schema => dep('/schema'),
    },
);

1;
