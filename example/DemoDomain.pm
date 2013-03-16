package DemoDomain;
use DDD::Domain;

#---------[ things needed by services or aggregates, set by constructor
has schema => (
    is  => 'ro',
    isa => 'DBIx::Class::Schema',
);

has storage => (
    is  => 'ro',
    isa => 'Object',
);

has 
log => (
    is  => 'ro',
    isa => 'Object',
);

has user => (
    is  => 'ro',
    isa => 'Maybe[Object]',
);

#---------[ Services: singletons (in our case: per Request)
service file_service => (
    isa          => 'My::Service',
    dependencies => [ 'storage' ],
);

service security => (
    isa          => 'My::SecurityService',
    dependencies => [ 'schema' ],
);

#---------[ Aggregates: private attribute and public method for param-handling
aggregate orderlist => (
    isa          => 'My::Aggregate',
    dependencies => [ qw(schema security log) ],
);

1;
