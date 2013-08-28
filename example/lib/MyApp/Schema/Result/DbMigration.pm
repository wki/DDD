use utf8;
package MyApp::Schema::Result::DbMigration;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyApp::Schema::Result::DbMigration

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

=head1 TABLE: C<db_migration>

=cut

__PACKAGE__->table("db_migration");

=head1 ACCESSORS

=head2 version

  data_type: 'integer'
  is_nullable: 0

=head2 created

  data_type: 'timestamp'
  is_nullable: 0

=head2 updated

  data_type: 'timestamp'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "version",
  { data_type => "integer", is_nullable => 0 },
  "created",
  { data_type => "timestamp", is_nullable => 0 },
  "updated",
  { data_type => "timestamp", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</version>

=back

=cut

__PACKAGE__->set_primary_key("version");

=head1 RELATIONS

=head2 db_scripts

Type: has_many

Related object: L<MyApp::Schema::Result::DbScript>

=cut

__PACKAGE__->has_many(
  "db_scripts",
  "MyApp::Schema::Result::DbScript",
  { "foreign.version" => "self.version" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-08-27 21:57:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:aA8CreOY7/zrCcqyj9VzxA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
