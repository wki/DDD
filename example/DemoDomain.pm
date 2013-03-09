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

#---------[ Aggregates: private attribute and public method for param-handling
has _orderlist => (
    is           => 'ro',
    isa          => 'My::Aggregate',
    dependencies => {
        schema   => 'schema',
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
        schema   => 'schema',
        root_dir => 'root_dir',
    },
    lifecycle    => 'Singleton',
);

__PACKAGE__->meta->make_immutable;
1;
