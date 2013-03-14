package DDD::Domain;
use Moose ();
use Moose::Exporter;
use Sub::Install;

extends 'Bread::Board::Declare';

Moose::Exporter->setup_import_methods(
    with_meta => ['aggregate', 'service'],
    also      => ['Moose', 'Bread::Board::Declare'],
);

sub aggregate {
    my ($meta, $name, @args) = @_;

    my $package = caller;
    
    # _name attribute as a service
    Moose::has($meta, "_$name", is => 'ro', @args);

    # name method as accessor
    Sub::Install::install_sub({
        code => sub {
            my $self = shift;
            
            return $self->resolve(
                service    => "_$name",
                parameters => { @_ },
            );
        },
        into => $package,
        as   => $name
    });
}

sub service {
    my ($meta, $name, @args) = @_;
    
    # name attribute as a service
    Moose::has($meta, $name, is => 'ro', lifecycle => 'Singleton', @args);
}

__PACKAGE__->meta->make_immutable;
1;
