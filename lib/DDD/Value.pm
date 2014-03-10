package DDD::Value;
use Moose;
use Scalar::Util 'blessed';
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
        next if substr($attribute,0,1) eq '_';
        
        my $my_attribute    = $self->$attribute;
        my $other_attribute = $other_value->$attribute;
        
        if (blessed $my_attribute && $my_attribute->can('is_equal')) {
            return $my_attribute->is_equal($other_attribute);
        }
        
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
