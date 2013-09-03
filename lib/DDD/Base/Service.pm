package DDD::Base::Service;
# use DDD::Meta::Class::Trait::Subscribe; # FIXME: can we avoid this line?
# use Moose -traits => 'Subscribe';
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

our %seen;
sub BUILD {
    my $self = shift;
    my $meta = $self->meta;
    
    return if $seen{ref $self}++;
    
    my %methods = map { ($_ => 1) } $meta->get_method_list;
    delete $methods{$_} for 'meta', $meta->get_attribute_list;
    
    warn 'Service is built.';
    warn 'methods: ' . join(', ', sort keys %methods);
    
    foreach my $method_name (sort keys %methods) {
        $meta->add_around_method_modifier(
            $method_name,
            sub {
                my ($orig, $self, @args) = @_;
                
                warn "METHOD '$method_name' before";
                my $result = $self->$orig(@args);
                warn "METHOD '$method_name' after";
                return $result;
            }
        );
    }
}

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
