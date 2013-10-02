package Vanilla::Sales;
use DDD::Domain;

service sell_service => (
    isa          => 'SellService',
    dependencies => {
        schema => dep('/schema'),
    },
);

1;
