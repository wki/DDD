package DDD::Domain;
use Moose ();
use Moose::Exporter;
use Carp;
use Sub::Install;
use Module::Load;
use Bread::Board::Declare ();
use Bread::Board::ConstructorInjection (); # make sure it is loaded.

Moose::Exporter->setup_import_methods(
    with_meta => [
        'has',
        'service', 'subdomain', 'factory', 'repository'
    ],
    also      => [
        # with_meta has precedence over 'also' -- see Moose::Exporter
        'Moose', 'Bread::Board::Declare'
    ],
);

sub init_meta {
    my $package = shift;
    my %args    = @_;

    Moose->init_meta(%args);

    # FIXME: wir brauchen eine Unterscheidung zwischen Domain und Subdomain.
    #        evtl. gelingt es, diesen Teil in die eigentliche Klasse
    #        zu packen und alles andere in DDD::Container.
    my $meta = $args{for_class}->meta;
    $meta->superclasses('DDD::Base::Domain');

    return $meta;
}

sub has {
    my ($meta, $name, %args) = @_;

    # this method is curried (!)
    my $package = caller(1);

    if (exists $args{lifecycle} && $args{lifecycle} =~ m{\bRequest\b}xms) {
        $args{lazy}    = 1;
        $args{clearer} = "_clear_$name";
        $args{default} = sub { $_[0]->_request_values->{$name} };
    }

    if (!exists $args{dependencies} || ref $args{dependencies} eq 'ARRAY') {
        push @{$args{dependencies}}, 'domain';
    } else {
        $args{dependencies}->{domain} = Bread::Board::Declare::dep('/domain');
    }

    Moose::has(
        $meta, $name,
        is => 'ro',
        %args,
    );
}

sub factory {
    my ($meta, $name, %args) = @_;

    my $package = caller(1);
    _resolve_isa_classes($package, \%args);

    _install(
        'factory',
        $meta, $name,
        \%args,
    );
}

sub repository {
    my ($meta, $name, %args) = @_;

    my $package = caller(1);
    _resolve_isa_classes($package, \%args);

    _install(
        'repository',
        $meta, $name,
        \%args,
    );
}

sub subdomain {
    my ($meta, $name, %args) = @_;

    # TODO: does loading the isa-class make sense?
    # TODO: does prefixing the $name with $package make sense?
    my $package = caller(1);
    _resolve_isa_classes($package, \%args);

    my $class = $args{isa};

    _install(
        'subdomain',
        $meta, $name,
        {
            %args,
            default => sub {
                my $self = shift;

                my $service = $class->new(name => $name);
                $self->add_sub_container($service);

                warn "SUBDOMAIN $name = $service";

                return $service;
            }
        }
    );
}

sub service {
    my ($meta, $name, %args) = @_;

    my $package = caller(1);
    _resolve_isa_classes($package, \%args);

    _install(
        'service',
        $meta, $name,
        \%args,
    );
    
    my $metax = $package->meta->get_attribute($name);
    warn "installed service '$name' (meta=$metax)";
}

sub _install {
    my ($thing, $meta, $name, $args) = @_;

    # this method is curried (!)
    my $package = caller(2);
    
    # _resolve_isa_classes($package, $args);

    # name attribute as a service
    $args->{dependencies} //= {};
    if (ref $args->{dependencies} eq 'ARRAY') {
        # FIXME: make this work if possible.
        push @{$args->{dependencies}}, 'domain';
        die "$thing '$name': ArrayRef dependencies do not work, sorry.";
    } else {
        $args->{dependencies}->{domain} = Bread::Board::Declare::dep('/domain');
    }

    my $class = $args->{isa}
        or croak "Service '$name': isa is missing";

    Moose::has(
        $meta, $name,
        is        => 'ro',
        lifecycle => 'Singleton',
        # default   => $builder,
        # lazy      => 1,
        %$args,
    );
}

sub _resolve_isa_classes {
    my ($package, $args) = @_;

    return if !exists $args->{isa};
    $args->{isa} =~ s{\A [+]}{}xms
        or $args->{isa} = "$package\::$args->{isa}";

    load $args->{isa};
}

1;
