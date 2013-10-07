package DDD::Role::EventPublisher;
use Moose::Role;
use MooseX::Storage;
use DDD::EventPublisher;

=head1 NAME

DDD::Base::EventEmitter - Base class for all event emitting objects

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

=cut

=head2 event_publisher

=cut

has event_publisher => (
    traits     => [ 'DoNotSerialize' ],
    is         => 'ro',
    isa        => 'DDD::EventPublisher',  ### TODO: make customizable
    predicate  => 'has_event_publisher',
    lazy_build => 1,
    handles    => [
        'publish', 'process_events',
    ],
);

sub _build_event_publisher {
    my $self = shift;
    
    return DDD::EventPublisher->instance;
}

=head1 METHODS

=cut

1;

=head1 AUTHOR

Wolfgang Kinkeldei, E<lt>wolfgang@kinkeldei.deE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
