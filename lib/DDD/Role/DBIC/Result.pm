package DDD::Role::DBIC::Result;
use Moose::Role;

requries qw(schema resultset);

=head1 NAME

DDD::Role::Schema

=head1 SYNOPSIS

    with 'DDD::Role::DBIC::Result';

=head1 DESCRIPTION

=head1 ATTRIBUTES

=cut

=head2 row

=cut

has row => (
    is => 'rw',
    isa => 'DBIx::Class::Row',
    predicate => 'has_row',
    ### TODO: how to add a handles...
);

=head1 METHODS

=cut

=head2 load ( $id )

loads a record by its id

=cut

sub load {
    my $self = shift;
    my $id = shift
        or die 'no ID provided for loading';
    
    
}

=head2 save

saves a row

=cut

sub save {
    my $self = shift;
    
    ...
}

=head2 create ( \%data )

create a new record

=cut

sub create {
    my $self= shift;
    
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
