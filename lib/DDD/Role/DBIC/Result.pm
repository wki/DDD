package DDD::Role::DBIC::Result;
use Moose::Role;
use Carp;

requires qw(schema _resultset_name _handles id);

=head1 NAME

DDD::Role::DBIC::Result -- do magic with DBIC Result Objects

=head1 SYNOPSIS

    with 'DDD::Role::DBIC::Result';

=head1 DESCRIPTION

no need to use this role directly -- Entity and Aggragate use this role

=head1 ATTRIBUTES

=cut

sub BUILD {
    my $self = shift;
    
    ### TODO: create methods for accessing row-methods based on _handles
    #
    # :primary -> all primary keys
    # :columns -> all column names
    # :relations -> all relation names
    # :methods -> all extra defined method names
    # :all -> everything above
    # name -> a method name
    # -name -> not a method name
    
    my $meta = $self->meta;
    return if $meta->has_method('__is_initialized__');
    warn "NOT INITIALIZED";

    my %methods;
    my $result_source = $self->resultset->result_source;
    my %is_primary = map { ($_ => 1)} $result_source->primary_columns;

    foreach my $handle_keyword ($self->_handles) {
        if ($handle_keyword =~ m{\A (?: :primary | :all) \z}xms) {
            $methods{$_} = 1
                for keys %is_primary;
        } elsif ($handle_keyword =~ m{\A (?: :columns | :all) \z}xms) {
            $methods{$_} = 1
                for grep { !$is_primary{$_} } $result_source->columns;
        } elsif ($handle_keyword =~ m{\A (?: :relations | :all) \z}xms) {
            $methods{$_} = 1
                for $result_source->relationships;
        } elsif ($handle_keyword =~ m{\A (?: :methods | :all) \z}xms) {
            # TODO: how to find out the methods?
        } elsif ($handle_keyword =~ s{\A -}{}xms) {
            delete $methods{$handle_keyword};
        } else {
            $methods{$handle_keyword} = 1;
        }
    }

    my $is_immutable = $meta->is_immutable;
    
    $self->meta->make_mutable if $is_immutable;
    
    foreach my $method (keys %methods) {
        $self->meta->add_method(
            $method => sub { 
                my $self = shift;
                $self->row->$method(@_);
            }
        )
    }
    
    $self->meta->add_method(__is_initialized__ => sub { });
    $self->meta->make_immutable if $is_immutable;
}

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
    
    return $self->schema->resultset($self->_resultset_name);
}

=head2 row

=cut

has row => (
    is         => 'rw',
    isa        => 'DBIx::Class::Row',
    lazy_build => 1,
);

sub _build_row {
    my $self = shift;
    
    $self->resultset->find($self->id);
}

=head1 METHODS

=cut

=cut

=head2 load ( [$id | $row_object] )

loads a record by its ID. The ID may be provided either to the load() method
or given as a construction argument in the class.

=cut

sub load {
    my $self = shift;
    
    my $id_or_row = shift;
    if (ref $id_or_row) {
        $self->row($id_or_row);
        $self->_id($self->row->id);
    } elsif (defined $id_or_row) {
        $self->_id($id_or_row);
    }
    
    croak 'no ID provided for loading' if !$self->has_id;
    
    # force lazy loading
    my $row_built_by_lazy_builder = $self->row;
    
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
