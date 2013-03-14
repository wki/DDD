package DemoDomain;
use Moose;
use Bread::Board::Declare;
use namespace::autoclean;

#---------[ attributes needed by services or aggregates
has schema => (
    is  => 'ro',
    isa => 'DBIx::Class::Schema',
);

has root_dir => (
    is  => 'ro',
    isa => 'Path::Class::Dir',
);

has logger => (
    is  => 'ro',
    isa => 'Any', # ???
);

#---------[ Aggregates: private attribute and public method for param-handling
has _orderlist => (
    is           => 'ro',
    isa          => 'My::Aggregate',
    dependencies => {
        schema   => 'schema',
        security => 'security',
    }
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
        root_dir => 'root_dir',
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
