package Basic::Vault::SecretCreator;
use Moose;
use aliased 'Basic::Vault::Secret';
use namespace::autoclean;

extends 'DDD::Factory';

=head1 NAME

Basic::Vault::SecretCreator - a factory creating secrets

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=cut

=head2 new_secret ( $key )

creates a new secret from key with an empty phrase

=cut

sub new_secret {
    my ($self, $key) = @_;
    
    Secret->new(id => $key, phrase => '');
}

__PACKAGE__->meta->make_immutable;
1;

=head1 AUTHOR

Wolfgang Kinkeldei, E<lt>wolfgang@kinkeldei.deE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
