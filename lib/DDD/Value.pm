package DDD::Value;
use Moose;
use namespace::autoclean;

extends 'DDD::Base::Object';

=head1 NAME

DDD::Entity - base class for a value

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=cut

=head2 is_equal ( $value )

returns a true value if the value equals the given value

=cut

sub is_equal {
    my ($self, $other_value) = @_;
    
    return if ref $self ne ref $other_value;
    
    # FIXME: not correct if we have more complicated content. Improve!
    foreach my $attribute ($self->meta->get_attribute_list) {
        return if ($self->$attribute . '') ne ($other_value->$attribute . '');
    }
    
    return 1;
}

__PACKAGE__->meta->make_immutable;
1;

=head1 AUTHOR

Wolfgang Kinkeldei

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
