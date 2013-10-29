package DDD::TransactionManager;
use Moose;
use namespace::autoclean;

extends 'parent';
with 'role';

=head1 NAME

DDD::TransactionManager - abstract base class for a transaction manager

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=cut

=head2 begin_transaction

starts a new transaction

=cut

sub begin_transaction {}

=head2 commit

commits a transaction

=cut

sub commit {}

=head2 rollback

rolls back a transaction

=cut

sub rollback {}

__PACKAGE__->meta->make_immutable;
1;

=head1 AUTHOR

Wolfgang Kinkeldei, E<lt>wolfgang@kinkeldei.deE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
