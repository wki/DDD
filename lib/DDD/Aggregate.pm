package DDD::Aggregate;
use Moose;
use namespace::autoclean;

extends 'DDD::Entity';

=head1 NAME

DDD::Aggregate - base class for an aggregate

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=cut

=head2 must_satisfy

ensure all invariants defined are satisfied or die

=cut

sub must_satisfy {
    my $self = shift;
    
    ...
}

=head2 is_satisfied

returns a boolean based on a check if invariants are satisfied

=cut

sub is_satisfied {
    my $self = shift;
    
    ...
}

=head1 AUTHOR

Wolfgang Kinkeldei

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;
1;
