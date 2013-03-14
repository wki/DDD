package DemoDomain;
use Moose;
use Bread::Board::Declare;
use namespace::autoclean;

#---------[ attributes needed by services or aggregates
has schema => (
    is  => 'ro',
    isa => 'DBIx::Class::Schema',
    ### TODO: must coerce from code-ref
);

### better: Storage Infrastructure Reference
has storage => (
    is  => 'ro',
    isa => 'Infrastructure::Storage',
    ### TODO: must coerce from code-ref
);

has log => (
    is  => 'ro',
    isa => 'Object', # ???
    ### TODO: must coerce from code-ref
);

has user => (
    is  => 'ro',
    isa => 'Mabe[Object]',
    ### TODO: must coerce from code-ref
);

#---------[ Aggregates: private attribute and public method for param-handling
has _orderlist => (
    is           => 'ro',
    isa          => 'My::Aggregate',
    dependencies => {
        schema   => 'schema',
        security => 'security',
        log      => 'log',
    },
);

sub orderlist {
    my $self = shift;
    
    return $self->resolve(
        service    => '_orderlist', 
        parameters => { @_ },
    );
}

#---------[ Services: singleton attributes
has file_service => (
    is           => 'ro',
    isa          => 'My::Service',
    dependencies => {
        root_dir => 'storage_dir',
    },
    lifecycle    => 'Singleton',
);

has security => (
    is           => 'ro',
    isa          => 'My::SecurityService',
    dependencies => {
        schema   => 'schema',
    },
    lifecycle    => 'Singleton',
);

__PACKAGE__->meta->make_immutable;
1;
