use utf8;
package MyApp::Schema::Result::DbScript;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::DbScript

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

=head1 TABLE: C<db_script>

=cut

__PACKAGE__->table("db_script");

=head1 ACCESSORS

=head2 db_script_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'db_script_db_script_id_seq'

=head2 version

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 filename

  data_type: 'text'
  is_nullable: 0

=head2 executed

  data_type: 'timestamp'
  is_nullable: 0

=head2 is_success

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 message

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "db_script_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "db_script_db_script_id_seq",
  },
  "version",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "filename",
  { data_type => "text", is_nullable => 0 },
  "executed",
  { data_type => "timestamp", is_nullable => 0 },
  "is_success",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "message",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</db_script_id>

=back

=cut

__PACKAGE__->set_primary_key("db_script_id");

=head1 RELATIONS

=head2 version

Type: belongs_to

Related object: L<MyApp::Schema::Result::DbMigration>

=cut

__PACKAGE__->belongs_to(
  "version",
  "MyApp::Schema::Result::DbMigration",
  { version => "version" },
  { is_deferrable => 1, on_delete => "CASCADE,", on_update => "CASCADE," },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-08-27 21:57:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:VF5uDJXSuo0uC8Hqak0mGQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
