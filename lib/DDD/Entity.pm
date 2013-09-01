package DDD::Entity;
use Moose;
use namespace::autoclean;

### sub id; # implemented below, forward defined to satisfy with '...Result'
### sub _resultset_name { die 'no resultset defined' };
### sub _handles { ':all' };

extends 'DDD::Base::Object';
with 'DDD::Role::DBIC::Schema';
# with 'DDD::Role::DBIC::Result';

=head1 NAME

DDD::Entity - base class for an entity

=head1 SYNOPSIS

    package My::Entity::Foo;
    use Moose;
    
    extends 'DDD::Entity';
    
    ### NO! -- Role DBIC::Result is switched off
    ### # specify the resultset to fetch Records from
    ### sub _resultset_name { 'FooBar' }
    ### 
    ### # auto-define methods inside the Entity class to access Result methods
    ### # just like 'handles' directive in attribute definitions
    ### #
    ### # allowed keywords:
    ### # :primary, :columns, :methods, :all, name, -not_name
    ### sub _handles { ':all' }
    
    1;

=head1 DESCRIPTION

=head1 ATTRIBUTES

=cut

=head2 id

the primary key of an Entity

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
