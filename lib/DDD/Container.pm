package DDD::Container;
use Moose ();
use Moose::Exporter;
use Module::Load;
use Bread::Board::Declare ();

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

    if (exists $args{lifecycle} && $args{lifecycle} =~ m{\bRequest\b}xms) {
        $args{clearer}   = "_clear_$name";
        $args{block}     = sub { $_[1]->_request_values->{$name} };
        $args{lifecycle} = '+DDD::LifeCycle::Request';
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

sub aggregate {
    my ($meta, $name, %args) = @_;

    _install(
        'aggregate',
        $meta, $name,
        \%args,
    );
    
    $meta->prepare_class($args{isa});
}

sub subdomain {
    my ($meta, $name, %args) = @_;

    _install_container(
        'subdomain',
        $meta, $name,
        \%args,
    );
}

sub service {
    my ($meta, $name, %args) = @_;

    _install(
        'service',
        $meta, $name,
        \%args,
    );
    
    $meta->autoload_service($name);
}

sub _install_container {
    my ($thing, $meta, $name, $args) = @_;
    
    $args->{isa} //= _camelize($name);
    
    my $package = caller(2);
    _resolve_isa_classes($package, $args);
    
    my $class = $args->{isa};
    
    _install(
        $thing,
        $meta, $name,
        {
            %$args,
            default => sub {
                my $self = shift;
                
                # FIXME: what happens at sub-sub domain?????
                my $service = $class->new(name => $name, domain => $self);
                $self->add_sub_container($service);

                return $service;
            }
        },
        $package
    );
    
    $meta->autoload_container($name);
}

sub _install {
    my ($thing, $meta, $name, $args, $package) = @_;

    my $class = $args->{isa} //= _camelize($name);

    if (!$package) {
        # this method is curried (!)
        $package = caller(2);
        _resolve_isa_classes($package, $args);
    }

    $args->{dependencies} //= {};
    $args->{dependencies}->{domain} = Bread::Board::Declare::dep('/domain');
    
    if (exists $args->{lifecycle} && $args->{lifecycle} eq 'Request') {
        $args->{lifecycle} = '+DDD::LifeCycle::Request';
    } else {
        $args->{lifecycle} //= 'Singleton';
    }
    
    Moose::has(
        $meta, $name,
        is        => 'ro',
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
