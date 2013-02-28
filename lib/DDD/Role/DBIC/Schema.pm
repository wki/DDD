package DDD::Role::DBIC::Schema;
use Moose::Role;

=head1 NAME

DDD::Role::DBIC::Schema - add a schema attribute to your class

=head1 SYNOPSIS

    with 'DDD::Role::DBIC::Schema';

=head1 DESCRIPTION

=head1 ATTRIBUTES

=cut

=head2 schema

=cut

has schema => (
    is => 'ro',
    isa => 'DBIx::Class::Schema',
    required => 1,
);

=head1 AUTHOR

Wolfgang Kinkeldei

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;
1;
