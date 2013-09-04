package Demo::Domain;
use DDD::Domain;

has schema  => (is => 'ro', isa => 'Object');
has storage => (is => 'ro', isa => 'Object');

service test_service => (
    isa          => 'Demo::Domain::TestService',
    dependencies => {
        schema  => dep('/schema'),
        storage => dep('/storage'),
    },
);

1;
