package DDD::Event;
use Moose;
use DateTime;
use namespace::autoclean;

extends 'DDD::Base::Object';

=head1 NAME

DDD::Event - base class for an event

=head1 SYNOPSIS

    # define an event. Naming: noun + verb in past tense
    package XXX::ActionHappend;
    use Moose;
    extends 'DDD::Event';
    
    # add attributes and methods
    
    
    # fire the event somewhere
    $something->publish(Xxx::ActionHappened->new);

=head1 DESCRIPTION

=head1 ATTRIBUTES

=cut

=head2 occured_on

reflects the timestamp the event was created. Will get set automatically.

=cut

has occured_on => (
    is      => 'ro',
    isa     => 'DateTime',
    default => sub { DateTime->now(time_zone => 'local') },
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
