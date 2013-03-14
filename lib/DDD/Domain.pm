package DDD::Domain;
use Moose ();
use Moose::Exporter;
use Sub::Install 'install_sub';

extends 'Bread::Board::Declare';

Moose::Exporter->setup_import_methods(
    with_meta => [ qw(aggregate service) ],
    also      => 'Moose',
);

sub aggregate {
    my ($meta, $name, @args) = @_;
    
    Moose::has($meta, "_$name", is => 'ro', @args);

    my $package = caller;
    
    install_sub({
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
    
    Moose::has($meta, $name, is => 'ro', lifecycle => 'Singleton', @args);
}

__PACKAGE__->meta->make_immutable;
1;
