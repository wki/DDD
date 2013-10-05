package DDD::Base::EventEmitter;
use Moose;
use namespace::autoclean;

extends 'DDD::Base::Object';

=head1 NAME

DDD::Base::EventEmitter - Base class for all event emitting objects

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

=cut

has event_publisher => (
    is         => 'ro',
    isa        => 'DDD::EventPublisher',
    predicate  => 'has_event_publisher',
    # lazy_build => 1,
    handles    => [
        'publish', 'process_events',
    ],
);

# sub _build_event_publisher {
#     my $self = shift;
#     
#     # how can we guess?
# }

=head1 METHODS

=cut

__PACKAGE__->meta->make_immutable;
1;

=head1 AUTHOR

Wolfgang Kinkeldei, E<lt>wolfgang@kinkeldei.deE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
