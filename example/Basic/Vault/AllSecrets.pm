package Basic::Vault::AllSecrets;
use Moose;
use namespace::autoclean;

extends 'DDD::Repository';

our %secret_for;

=head1 NAME

Basic::Vault::AllSecrets - repository for saving and loading secrets

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

=cut

=head1 METHODS

=cut

=head2 by_key ( $key )

reconstitute a secret by key

=cut

sub by_key {
    my ($self, $key) = @_;
    
    return $secret_for{$key};
}

=head2 save ( $secret )

writes a secret into the storage

=cut

sub save {
    my ($self, $secret) = @_;
    
    $secret_for{$secret->id} = $secret;
}

__PACKAGE__->meta->make_immutable;
1;

=head1 AUTHOR

Wolfgang Kinkeldei, E<lt>wolfgang@kinkeldei.deE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
