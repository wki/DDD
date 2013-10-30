package Basic::App;
use DDD::Application;

=head1 NAME

Basic::App - blabla

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SERVICES

=cut

service 'keeper';

__PACKAGE__->meta->make_immutable;
1;

=head1 AUTHOR

Wolfgang Kinkeldei, E<lt>wolfgang@kinkeldei.deE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
