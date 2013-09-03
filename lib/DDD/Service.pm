package DDD::Service;
use Moose;
use namespace::autoclean;

Moose::Exporter->setup_import_methods(
    with_meta => [
        'on',
    ],
    class_metaroles => {
        class  => ['DDD::Service::Meta::Role::Class'],
        # method => ['DDD::Service::Meta::Role::Method'],
    },
    also => [
        # with_meta has precedence over 'also' -- see Moose::Exporter
        'Moose'
    ],
);

=head1 NAME

DDD::Service - DSL for Services

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=cut

sub init_meta {
    my $package = shift;
    my %args    = @_;

    Moose->init_meta(%args);

    my $meta = $args{for_class}->meta;
    $meta->superclasses('DDD::Base::Service');
    
    return $meta;
}

=head2 on

=cut

sub on {
    my ($meta, $event_name, $sub) = @_;
    
    # warn "on '$event_name' [meta=$meta]";
    
    # Service Class Metaobject must have the right trait applied
    $meta->subscribe_to($event_name, $sub);
}

=head1 AUTHOR

Wolfgang Kinkeldei

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;
1;
