package DDD::Domain;
use Moose ();
use Moose::Exporter;
use Sub::Install;
use Bread::Board::Declare ();
use Bread::Board::ConstructorInjection (); # be save it is loaded.

Moose::Exporter->setup_import_methods(
    with_meta => ['aggregate', 'service'],
    also      => ['Moose', 'Bread::Board::Declare'],
);

sub aggregate {
    my ($meta, $name, %args) = @_;

    # this method is curried (!)
    my $package = caller(1);

    _resolve_isa_classes($package, \%args);
    
    # _name attribute as a service
    Moose::has($meta, "_$name", is => 'ro', %args);

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
    my ($meta, $name, %args) = @_;
    
    # this method is curried (!)
    my $package = caller(1);

    _resolve_isa_classes($package, \%args);
    
    # name attribute as a service
    Moose::has($meta, $name, is => 'ro', lifecycle => 'Singleton', %args);
}

sub _resolve_isa_classes {
    my ($package, $args) = @_;
    
    return if !exists $args->{isa};
    $args->{isa} =~ s{\A [+]}{}xms and return;
    $args->{isa} = "$package\::$args->{isa}";
}

1;
