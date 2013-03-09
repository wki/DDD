package DemoDomain;
use Moose;
use Bread::Board::Declare;
use namespace::autoclean;

has schema => (
    is      => 'ro',
    isa     => 'DBIx::Class::Schema',
);

has root_dir => (
    is      => 'ro',
    isa     => 'Path::Class::Dir',
);

# one more method for every aggregate
has orderlist => (
    is           => 'ro',
    isa          => 'My::Aggregate',
    infer        => 1,
    # dependencies => {
    #     schema   => 'schema',
    # }
);

# one method for aggregates needing an extra ID
sub orderlist_with {
    my $self = shift;
    
    return $self->resolve(
        service => 'orderlist', 
        parameters => { @_ },
    );
}

# similar for services, but singleton
has file_service => (
    is           => 'ro',
    isa          => 'My::Service',
    infer        => 1,
    # dependencies => {
    #     schema   => 'schema',
    #     root_dir => 'root_dir',
    # },
    lifecycle    => 'Singleton',
);

__PACKAGE__->meta->make_immutable;
1;
