package DDD::EventPublisher;
use Moose;
use namespace::autoclean;

=head1 NAME

DDD::EventPublisher - a simple PubSub implementation

=head1 SYNOPSIS

    # TODO: add example

=head1 DESCRIPTION

TODO: write something

=head1 ATTRIBUTES

=cut

has _listeners => (
    traits => ['Array'],
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    handles => {
        _add_listener  => 'push',
        _all_listeners => 'elements',
    }
);


=head1 METHODS

=cut

=head2 add_listener ( $event, $target, $method )

adds the target object as a listener wanting to capture a given event.

=cut

sub add_listener {
    my ($self, $event, $target, $method) = @_;
    
    $self->_add_listener(
        { target => $target, event => $event, method => $method }
    );
}

=head2 remove_listener ( $event, $target, $method )

removes a listener

=cut

sub remove_listener {
    ...
}

=head2 publish ( $event_object )

publishes an event

=cut

sub publish {
    my ($self, $event_object) = @_;
    
    my $event_name = ref $event_object;
    $event_name =~ s{\A .* ::}{}xms;
        
    foreach my $listener ($self->_all_listeners) {
        my ($event, $target, $method) = @$listener{qw(event target method)};
        next if $event && $event ne $event_name;
        
        $target->$method($event_object);
    }
}

__PACKAGE__->meta->make_immutable;
1;

=head1 AUTHOR

Wolfgang Kinkeldei, E<lt>wolfgang@kinkeldei.deE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
