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

has log => (
    is  => 'ro',
    isa => 'Object', # ???
);

has user => (
    is  => 'ro',
    isa => 'Mabe[Object]',
);

#---------[ Aggregates: private attribute and public method for param-handling

aggregate orderlist => (
    isa          => 'My::Aggregate',
    dependencies => [ qw(schema security log) ],
);

# has _orderlist => (
#     is           => 'ro',
#     isa          => 'My::Aggregate',
#     dependencies => [ qw(schema security log) ],
# );
# 
# sub orderlist {
#     my $self = shift;
#     
#     return $self->resolve(
#         service    => '_orderlist', 
#         parameters => { @_ },
#     );
# }

#---------[ Services: singletons (in our case: per Request)

service file_service => (
    isa          => 'My::Service',
    dependencies => [ 'storage' ],
);

# has file_service => (
#     is           => 'ro',
#     isa          => 'My::Service',
#     dependencies => [ 'storage' ],
#     lifecycle    => 'Singleton',
# );

service security => (
    isa          => 'My::SecurityService',
    dependencies => [ 'schema' ],
);

# has security => (
#     is           => 'ro',
#     isa          => 'My::SecurityService',
#     dependencies => [ 'schema' ],
#     lifecycle    => 'Singleton',
# );

1;
