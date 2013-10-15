package DDD::Domain;
use Moose ();
use Moose::Exporter;
# use Carp;
use DDD::Container ();

=head1 NAME

DDD::Domain - DSL for creating a Domain class

=head1 SYNOPSIS

    package My::Domain;
    use DDD::Domain;
    use MooseX::Types::Path::Class 'Dir';
    
    # regular attributes are regular Moose attributes
    has storage_dir => (
        is     => 'ro',
        isa    => Dir,
        coerce => 1,
    );
    
    # subdivide your Domain into subdomains
    subdomain alarm => (
        # default: 'Alarm',
        isa => 'Alarm',         # resolves to My::Domain::Alarm
        dependencies => (
            # Bread::Board::Declare dependencies
        ),
    );
    
    # your application services sit here:
    application (
         # default: 'Application',
        isa => 'Application',   # resolves to My::Domain::Application
        dependencies => (
            # Bread::Board::Declare dependencies
        ),
    );
    
    1;
    
    
    package My::Domain::Alarm;
    use DDD::SubDomain;
    
    # optional attributes -- see Domain
    
    repository all_alarms;
    
    factory alarm_creator;
    
    service alarm_check => (
        dependencies => (
            # Bread::Board::Declare dependencies
        ),
    );
    
    aggregate alarm;

=head1 DESCRIPTION

TODO: write more

all classes (isa declaration) are guessed from the name by camelizing.

The domain- or subdomain-package is prepended to the class name.

=cut

Moose::Exporter->setup_import_methods(
    with_meta => [
        'application',
    ],
    class_metaroles => {
        class  => ['DDD::Container::Meta::Role::Class'],
    },
    also      => [
        # with_meta has precedence over 'also' -- see Moose::Exporter
        # the order is also important. DDD::Container must on top
        'DDD::Container',
        'Moose',
        'Bread::Board::Declare',
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

sub application {
    my ($meta, %args) = @_;
    
    DDD::Container::_install_container(
        'application',
        $meta, 'application',
        \%args
    );
}

1;

=head1 AUTHOR

Wolfgang Kinkeldei, E<lt>wolfgang@kinkeldei.deE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
