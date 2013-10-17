package DDD::SubDomain;
use Moose ();
use Moose::Exporter;
# use Carp;
use DDD::Container ();

=head1 NAME

DDD::SubDomain - DSL for creating a SubDomain class

=head1 SYNOPSIS

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

see DDD::Domain

=cut

Moose::Exporter->setup_import_methods(
    class_metaroles => {
        class  => ['DDD::Meta::Role::Class::Container'],
    },
    also => [
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
    $meta->superclasses('DDD::Base::SubDomain');

    return $meta;
}

1;

=head1 AUTHOR

Wolfgang Kinkeldei

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
