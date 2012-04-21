use utf8;
package CPANMonitor::Schema::Result::Alert;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

CPANMonitor::Schema::Result::Alert

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

=item * L<DBIx::Class::TimeStamp>

=item * L<DBIx::Class::PassphraseColumn>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "PassphraseColumn");

=head1 TABLE: C<alert>

=cut

__PACKAGE__->table("alert");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 distribution

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 abstract

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 author

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 version

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 checked

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 updated

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "distribution",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "abstract",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "author",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "version",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "checked",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
  "updated",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 user_alerts

Type: has_many

Related object: L<CPANMonitor::Schema::Result::UserAlert>

=cut

__PACKAGE__->has_many(
  "user_alerts",
  "CPANMonitor::Schema::Result::UserAlert",
  { "foreign.alert" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-04-17 19:35:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zQtVaFKmb6djZpFFpDDQUg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
