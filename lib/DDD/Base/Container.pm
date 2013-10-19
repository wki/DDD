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

    foreach my $container (@{$meta->autoload_containers}) {
        $self->log_debug(build => "autoload container: ${\ref $self} $container");
        $self->$container->autoload($domain);
    }

    foreach my $service (@{$meta->autoload_services}) {
        $self->log_debug(build => "autoload service: ${\ref $self} $service");
        try {
            $self->$service;
        } catch {
            s{\n.*\z}{...}xms;
            die "died: $_";
        };
    }
    
    foreach my $class (@{$meta->prepare_classes}) {
        $self->log_debug(build => "prepare class: ${\ref $self} $class");
        
        $class->meta->domain($domain);
    }
}

__PACKAGE__->meta->make_immutable;
1;
