package DDD::Base::Object;
use Moose;
use MooseX::Storage;
use DateTime;
use namespace::autoclean;

with Storage(format => 'JSON', io => 'File');

=head1 NAME

DDD::Base::Object - common base class for most DDD objects

=head1 SYNOPSIS

=head1 DESCRIPTION

applies MooseX::Storage role to every object magically adding C<pack> and
C<unpack> methods.

=head1 ATTRIBUTES

=cut

=head1 METHODS

=cut

=head2 _now

returns now as a DateTime Object

=cut

sub _now { DateTime->now( time_zone => 'local' ) }

=head1 AUTHOR

Wolfgang Kinkeldei

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

# __PACKAGE__->meta->make_immutable;
1;
