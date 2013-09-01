package DDD::Meta::Class::Trait::Subscribe;
use Moose::Role;

Moose::Util::meta_class_alias('Subscribe');

=head1 NAME

DDD::Meta::Class::Trait::Subscribe - blabla

=head1 SYNOPSIS

=head1 DESCRIPTION

a trait applied to classes intended for event listening. Typically only
application-services and domain-services are candidates for this.

In the construction phase the DSL-keyword 'on' captures the events for
listening inside the class meta object. This is provided by this class.

=head1 ATTRIBUTES

=cut

=head2 subscribed_events

contains all events with callbacks the service is subscribing to.
The reason is that the 'on' keyword only has access to the meta object of
the class.

=cut

has subscribed_events => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub { [] },
);

=head1 METHODS

=cut

=head2 subscribe_to ($event, $callback)

=cut

sub subscribe_to {
    my ($self, $event, $callback) = @_;
    
    warn "subscribe to '$event', [meta=$self]";
    push @{$self->subscribed_events}, { event => $event, callback => $callback };
}

1;

=head1 AUTHOR

Wolfgang Kinkeldei, E<lt>wolfgang@kinkeldei.deE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
