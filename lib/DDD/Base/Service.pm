package DDD::Base::Service;
use Moose;
use namespace::autoclean;

extends 'DDD::Base::EventEmitter';
with 'DDD::Role::Domain';

=head1 NAME

DDD::Base::Service - base class for a Domain- or Application-Service

=head1 SYNOPSIS

    package Domain::Xxx::Service;
    use DDD::Service;

    # define methods etc.

=head1 DESCRIPTION

Behind the scenes, DDD::Base::Service is taken as a super class.

=head1 ATTRIBUTES

=cut

=head1 METHODS

=cut

sub BUILD {
    my $self = shift;

    # allow a Service DSL package to be mutable before we mangle it.
    $self->meta->make_mutable if $self->meta->is_immutable;

    $self->_construct_method_modifiers;
    $self->_add_event_listeners;

    $self->meta->make_immutable;

    $self->log_debug(build => "service ${\ref $self}");
}

our %seen;
sub _construct_method_modifiers {
    my $self = shift;
    my $meta = $self->meta;

    return if $seen{ref $self}++;

    my %methods = map { ($_ => 1) } grep { !m{\A _}xms } $meta->get_method_list;
    delete $methods{$_} for 'meta', $meta->get_attribute_list;

    foreach my $method_name (sort keys %methods) {
        $meta->add_around_method_modifier(
            $method_name,
            sub {
                my ($orig, $self, @args) = @_;

                $self->_enter_method($method_name);

                my $result = $self->$orig(@args);

                # FIXME: does a warning make sense if events are expected
                #        but no eventpublisher is present?

                $self->process_events;

                $self->_leave_method($method_name);

                return $result;
            }
        );
    }
}

sub _add_event_listeners {
    my $self = shift;

    $self->event_publisher->add_listener(
        $_->{event}, $self, $_->{callback},
    )
        for $self->all_subscribed_events;
}

=head2 _enter_method ( $method_name )

a pluggable hook called before entering the body of a service method

=cut

sub _enter_method {}

=head2 _leave_method ( $method_name )

a pluggable hook called after leaving the body of a service method

=cut

sub _leave_method {}


=head2 all_subscribed_events

returns all events this Service is listening to. Events are defined with the
'on' keyword. See L<DDD::Service> for further info.

Depending on context, returns a list or an arrayref.

=cut

sub all_subscribed_events {
    my $self = shift;

    my $subscribed_events = $self->meta->subscribed_events;

    return wantarray
        ? @$subscribed_events
        : $subscribed_events;
}

=head1 AUTHOR

Wolfgang Kinkeldei, E<lt>wolfgang@kinkeldei.deE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;
1;
