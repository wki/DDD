package Basic::Vault;
use DDD::SubDomain;

=head1 NAME

Basic::Vault - a subdomain keeping and reporting back secret phrases

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

repository 'all_secrets';

factory 'secret_creator';

aggregate 'secret';

__PACKAGE__->meta->make_immutable;
1;

=head1 AUTHOR

Wolfgang Kinkeldei, E<lt>wolfgang@kinkeldei.deE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
