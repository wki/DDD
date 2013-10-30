package Basic::Vault::Secret;
use Moose;
use aliased 'Basic::Vault::SecretChanged';
use namespace::autoclean;

extends 'DDD::Aggregate';

=head1 NAME

Basic::Vault::Secret - aggregate keeping a secret

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

=cut

has phrase => (
    is     => 'rw',
    isa    => 'Str',
    writer => '_set_phrase',
);

=head1 METHODS

=cut

=head2 change_phrase ( $new_phrase )

=cut

sub change_phrase {
    my ($self, $new_phrase) = @_;
    
    return if $self->phrase eq $new_phrase;
    
    $self->_set_phrase($new_phrase);
    $self->publish(
        SecretChanged->new(key => $self->id, phrase => $new_phrase)
    );
}

__PACKAGE__->meta->make_immutable;
1;

=head1 AUTHOR

Wolfgang Kinkeldei, E<lt>wolfgang@kinkeldei.deE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
