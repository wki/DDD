package DDD::Role::DBIC::Result;
use Moose::Role;
use Carp;

requires qw(schema resultset_name id);

=head1 NAME

DDD::Role::Schema

=head1 SYNOPSIS

    with 'DDD::Role::DBIC::Result';

=head1 DESCRIPTION

=head1 ATTRIBUTES

=cut

=head2 resultset

a resultset used for calling ->find() on. May be modified by inheriting
classes by overwriting/modifying "_build_resultset"

=cut

has resultset => (
    is         => 'ro',
    isa        => 'DBIx::Class::ResultSet',
    lazy_build => 1,
);

sub _build_resultset {
    my $self = shift;
    
    return $self->schema->resultset($self->resultset_name);
}

=head2 row

=cut

has row => (
    is         => 'rw',
    isa        => 'DBIx::Class::Row',
    lazy_build => 1,
    ### TODO: how to add a handles...
);

sub _build_row {
    my $self = shift;
    
    $self->resultset->find($self->id);
}

=head1 METHODS

=cut

=cut

=head2 load ( [$id] )

loads a record by its ID. The ID may be provided either to the load() method
or given as a construction argument in the class.

=cut

sub load {
    my $self = shift;
    
    $self->_id(shift) if @_;
    croak 'no ID provided for loading' if !$self->has_id;
    
    my $lazily_built_row = $self->row;
    
    return $self;
}

=head2 save

saves a row

=cut

sub save {
    my $self = shift;
    
    if ($self->row->in_storage) {
        $self->row->update;
    } else {
        $self->row->insert;
    }
    
    return $self;
}

=head2 init ( \%data )

create a new record

=cut

sub init {
    my $self= shift;
    
    $self->row( $self->resultset->new_result( { @_ } ) );
    
    return $self;
}

=head2 undo

undo latest changes and revert to saved record. Dies if no record is saved.

=cut

sub undo {
    my $self = shift;
    
    $self->load;
    
    return $self;
}

=head1 AUTHOR

Wolfgang Kinkeldei

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
