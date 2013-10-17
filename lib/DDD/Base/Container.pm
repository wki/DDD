package DDD::Base::Container;
use Moose;
use Bread::Board::Declare;
use namespace::autoclean;

sub autoload {
    my $self = shift;

    my $meta = $self->meta;

    foreach my $container (@{$meta->autoload_containers}) {
        $self->log_debug(build => "autoload container: ${\ref $self} $container");
        $self->$container->autoload;
    }

    foreach my $service (@{$meta->autoload_services}) {
        $self->log_debug("autoload service: ${\ref $self} $service");
        # try {
        #     $self->$service;
        # } catch {
        #     s{\n.*\z}{...}xms;
        #     die "died: $_";
        # };
    }
}

__PACKAGE__->meta->make_immutable;
1;
