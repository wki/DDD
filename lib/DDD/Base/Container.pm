package DDD::Base::Container;
use Moose;
use Try::Tiny;
use Bread::Board::Declare;
use namespace::autoclean;

sub autoload {
    my ($self, $domain) = @_;

    my $meta = $self->meta;
    
    # only happens during tests with too simple Mocks...
    return if !$meta->can('autoload_containers');
    
    
    # TODO: vereinfachen. Wir merken uns _nur_ noch "Kindelemente" und Klassen
    # dann wird bei Kindern:
    #   - lesend auf Kind zugegriffen
    #   - autoload() aufgerufen falls möglich
    # Klassen:
    #   - meta->domain() gesetzt falls existent (wir bisher)

    foreach my $container (@{$meta->autoload_containers}) {
        $self->log_debug(build => "autoload container: ${\ref $self} $container");
        $self->$container->autoload($domain);
    }

    foreach my $service (@{$meta->autoload_services}) {
        $self->log_debug(build => "autoload service: ${\ref $self} $service");
        $self->$service;
    }
    
    foreach my $class (@{$meta->prepare_classes}) {
        $self->log_debug(build => "prepare class: ${\ref $self} $class");
        $class->meta->domain($domain);
    }
}

__PACKAGE__->meta->make_immutable;
1;
