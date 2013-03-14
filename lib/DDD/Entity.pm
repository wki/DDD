package DDD::Entity;
use Moose;
use namespace::autoclean;

extends 'DDD::Base';
with 'DDD::Role::DBIC::Schema',
     'DDD::Role::DBIC::Result';

=head1 NAME

DDD::Entity - base class for an entity

=head1 SYNOPSIS

    package My::Entity::Foo;
    use Moose;
    
    extends 'DDD::Entity';
    
    sub resultset_name { 'FooBar' }
    
    1;

=head1 DESCRIPTION

=head1 ATTRIBUTES

=cut

=head2 id

=cut

has id => (
    is        => 'ro',
    isa       => 'Str',
    writer    => '_id',
    predicate => 'has_id',
);

=head1 METHODS

=cut

=head1 AUTHOR

Wolfgang Kinkeldei

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;
1;
