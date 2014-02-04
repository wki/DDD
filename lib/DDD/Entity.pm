package DDD::Entity;
use Moose;
use namespace::autoclean;

extends 'DDD::Base::EventEmitter';

=head1 NAME

DDD::Entity - base class for an entity

=head1 SYNOPSIS

    package My::Foo;
    use Moose;
    
    extends 'DDD::Entity';
    
    # define attributes and methods as usual
    
    1;

=head1 DESCRIPTION

=head1 ATTRIBUTES

=cut

=head2 id

the primary key of an Entity. mandatory.

=cut

has id => (
    is        => 'ro',
    isa       => 'Str',
    writer    => '_id',     # a Repository might need to set the ID
    predicate => 'has_id',
);

=head1 METHODS

=cut

=head2 is_equal ( $entity )

returns a true value if the entity equals the given entity

=cut

sub is_equal {
    my ($self, $other_entity) = @_;

    return if ref $self ne ref $other_entity;
    return if !($self->has_id && $other_entity->has_id);

    return $self->id eq $other_entity->id;
}

=head1 AUTHOR

Wolfgang Kinkeldei

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;
1;
