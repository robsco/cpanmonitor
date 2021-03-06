use utf8;
package CPANMonitor::Schema::Result::UserAlert;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

CPANMonitor::Schema::Result::UserAlert

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

=head1 TABLE: C<user_alert>

=cut

__PACKAGE__->table("user_alert");

=head1 ACCESSORS

=head2 user

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 alert

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 development

  data_type: 'tinyint'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 email

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 added

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "alert",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "development",
  { data_type => "tinyint", extra => { unsigned => 1 }, is_nullable => 0 },
  "email",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "added",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</user>

=item * L</alert>

=back

=cut

__PACKAGE__->set_primary_key("user", "alert");

=head1 UNIQUE CONSTRAINTS

=head2 C<user_alert_email>

=over 4

=item * L</user>

=item * L</alert>

=item * L</email>

=back

=cut

__PACKAGE__->add_unique_constraint("user_alert_email", ["user", "alert", "email"]);

=head1 RELATIONS

=head2 alert

Type: belongs_to

Related object: L<CPANMonitor::Schema::Result::Alert>

=cut

__PACKAGE__->belongs_to(
  "alert",
  "CPANMonitor::Schema::Result::Alert",
  { id => "alert" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 user

Type: belongs_to

Related object: L<CPANMonitor::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "CPANMonitor::Schema::Result::User",
  { id => "user" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-04-22 00:44:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/ZdW7qCe01UZGHNAUk9rKg

__PACKAGE__->add_columns(
    "added",
    { data_type => 'timestamp', set_on_create => 1 },
);


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
