package DDD::Service::Meta::Role::Method;
use Moose::Role;
use namespace::autoclean;

=head1 NAME

DDD::Service::Meta::Role::Method - role for Service Method Meta Object

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 ATTRIBUTES

=cut

=head1 METHODS

=cut

# after execute => sub {
#     warn "Meta::Role::Method executed";
# };

sub execute {
    warn 'Meta::Role::Method executed';
}

1;

=head1 AUTHOR

Wolfgang Kinkeldei, E<lt>wolfgang@kinkeldei.deE<gt>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
