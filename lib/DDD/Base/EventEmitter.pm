package DDD::Base::EventEmitter;
use Moose;
use namespace::autoclean;

extends 'DDD::Base::Object';
with 'DDD::Role::EventPublisher';

=head1 NAME

DDD::Base::EventEmitter - Base class for all event emitting objects

=head1 SYNOPSIS

=head1 DESCRIPTION

see Role::EventPublisher

=head1 ATTRIBUTES

=cut

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
