package DDD::Event;
use Moose;
use DateTime;
use namespace::autoclean;

extends 'DDD::Base::Object';

=head1 NAME

DDD::Event - base class for an event

=head1 SYNOPSIS

    # define an event. Naming: noun + verb in past tense
    package My::ActionHappend;
    use Moose;
    extends 'DDD::Event';
    
    # add attributes
    
    
    # fire the event somewhere
    package My::Whatever;
    use aliased 'Xxx::ActionHappened';
    
    $something->publish(ActionHappened->new(...));
    
    
    # catch the event inside a service
    package My::Foo;
    use 'DDD::Service';
    
    on ActionHappened => sub {
        my ($self, $event) = @_;
        
        # ...
    };

=head1 DESCRIPTION

=head1 ATTRIBUTES

=cut

=head2 occured_on

reflects the timestamp the event was created. Will get set automatically.

=cut

has occured_on => (
    is      => 'ro',
    isa     => 'DateTime',
    default => sub { $_[0]->_now },
);

=head1 METHODS

=cut

=head1 AUTHOR

Wolfgang Kinkeldei

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;
1;
