package DDD::Container;
use Moose ();
use Moose::Exporter;
use Carp;
use Module::Load;
use Bread::Board::Declare ();
use Bread::Board::ConstructorInjection (); # make sure it is loaded.

=head1 NAME

DDD::Container - common functionality for DDD::Domain and DDD::SubDomain

=head1 SYNOPSIS

see DDD::Domain

=head1 DESCRIPTION

=cut

Moose::Exporter->setup_import_methods(
    with_meta => [
        'has',
        'service', 'subdomain', 'factory', 'repository', 'aggregate',
    ],
);

sub has {
    my ($meta, $name, %args) = @_;

    # this method is curried (!)
    # my $package = caller(1);

    if (exists $args{lifecycle} && $args{lifecycle} =~ m{\bRequest\b}xms) {
        $args{lazy}    = 1;
        $args{clearer} = "_clear_$name";
        $args{default} = sub { $_[0]->_request_values->{$name} };
    }

    # if (!exists $args{dependencies} || ref $args{dependencies} eq 'ARRAY') {
    #     push @{$args{dependencies}}, 'domain';
    # } else {
    #     $args{dependencies}->{domain} = Bread::Board::Declare::dep('/domain');
    # }
    
    warn "DDD::Container::has $name";

    Moose::has(
        $meta, $name,
        is => 'ro',
        %args,
    );
}

sub factory {
    my ($meta, $name, %args) = @_;

    # my $package = caller(1);
    # _resolve_isa_classes($package, \%args);

    _install(
        'factory',
        $meta, $name,
        \%args,
    );
}

sub repository {
    my ($meta, $name, %args) = @_;

    # my $package = caller(1);
    # _resolve_isa_classes($package, \%args);

    _install(
        'repository',
        $meta, $name,
        \%args,
    );
}

sub aggregate {
    my ($meta, $name, %args) = @_;

    # my $package = caller(1);
    # _resolve_isa_classes($package, \%args);

    _install(
        'aggregate',
        $meta, $name,
        \%args,
    );
}

sub subdomain {
    my ($meta, $name, %args) = @_;

    # TODO: does loading the isa-class make sense?
    # TODO: does prefixing the $name with $package make sense?
    # my $package = caller(1);
    # _resolve_isa_classes($package, \%args);

    _install_container(
        'subdomain',
        $meta, $name,
        \%args,
    );
}

sub service {
    my ($meta, $name, %args) = @_;

    # my $package = caller(1);
    # _resolve_isa_classes($package, \%args);

    _install(
        'service',
        $meta, $name,
        \%args,
    );
    
    # my $metax = $package->meta->get_attribute($name);
    # warn "installed service '$name' (meta=$metax)";
    
    $meta->autoload_service($name);
}

sub _install_container {
    my ($thing, $meta, $name, $args) = @_;
    
    my $class = $args->{isa} //= _camelize($name);
    
    _install(
        $thing,
        $meta, $name,
        {
            %$args,
            default => sub {
                my $self = shift;

                my $service = $class->new(name => $name);
                $self->add_sub_container($service);

                return $service;
            }
        }
    );
    
    $meta->autoload_container($name);
}

sub _install {
    my ($thing, $meta, $name, $args) = @_;

    # this method is curried (!)
    my $package = caller(2);
    _resolve_isa_classes($package, $args);

    # # name attribute as a service
    # $args->{dependencies} //= {};
    # if (ref $args->{dependencies} eq 'ARRAY') {
    #     # FIXME: make this work if possible.
    #     push @{$args->{dependencies}}, 'domain';
    #     die "$thing '$name': ArrayRef dependencies do not work, sorry.";
    # } else {
    #     $args->{dependencies}->{domain} = Bread::Board::Declare::dep('/domain');
    # }

    my $class = $args->{isa} //= _camelize($name);

    warn "DDD::Container::$thing $name [$args->{isa}]";

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

sub _camelize {
    my $name = shift;
    
    $name =~ s{(?:\A|_+) (.)}{\u$1}xmsg;
    
    return $name;
}

1;

=head1 AUTHOR

Wolfgang Kinkeldei, E<lt>wolfgang@kinkeldei.deE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
