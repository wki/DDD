package Basic::Vault::SecretChanged;
use Moose;

extends 'DDD::Event';

=head1 NAME

Basic::Vault::SecretChanged - event fired after a secret has changed

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

=cut

has key => (
    is  => 'ro',
    isa => 'Str',
);

has phrase => (
    is  => 'ro',
    isa => 'Str',
);

__PACKAGE__->meta->make_immutable;
1;

=head1 AUTHOR

Wolfgang Kinkeldei, E<lt>wolfgang@kinkeldei.deE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
