package DDD::Domain;
use Moose ();
use Moose::Exporter;
use Carp;
use Sub::Install;
use Bread::Board::Declare ();
use Bread::Board::ConstructorInjection (); # be save it is loaded.

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

    my $meta = $args{for_class}->meta;
    $meta->superclasses('DDD::Base::Domain');

    return $meta;
}

sub has {
    my ($meta, $name, %args) = @_;

    # this method is curried (!)
    my $package = caller(1);

    # _resolve_isa_classes($package, \%args);

    # TODO: check lifecycle and add to 'Request' scope List
    if (exists $args{lifecycle} && $args{lifecycle} =~ m{\bRequest\b}xms) {
        $args{clearer}   = "_clear_$name";
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

    _install(
        'factory',
        $meta, $name,
        \%args,
    );
}

sub repository {
    my ($meta, $name, %args) = @_;

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

    my $class = $args{isa};

    _install(
        'subdomain',
        $meta, $name,
        {
            %args,
            builder => sub {
                my $self = shift;

                my $service = $class->new(name => $name);
                $self->add_sub_container($service);

                return $service;
            }
        }
    );
}

sub service {
    my ($meta, $name, %args) = @_;

    _install(
        'service',
        $meta, $name,
        \%args,
    );
}

sub _install {
    my ($thing, $meta, $name, $args) = @_;

    # this method is curried (!)
    my $package = caller(2);

    _resolve_isa_classes($package, $args);

    # name attribute as a service
    if (!exists $args->{dependencies} || ref $args->{dependencies} eq 'ARRAY') {
        # FIXME: make this work if possible.
        push @{$args->{dependencies}}, 'domain';
        die 'ArrayRef dependencies do not work, sorry.';
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

    # return if !exists $args->{isa};
    # $args->{isa} =~ s{\A [+]}{}xms and return;
    # $args->{isa} = "$package\::$args->{isa}";
}

1;
