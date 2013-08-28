use utf8;
package MyApp::Schema::Result::Dummy;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::Dummy

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<dummy>

=cut

__PACKAGE__->table("dummy");

=head1 ACCESSORS

=head2 dummy

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns("dummy", { data_type => "text", is_nullable => 1 });


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-08-27 21:57:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EiHf0NReDqleTxvs56ISuw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
