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

=head2 released

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

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
  "released",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
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

=head1 UNIQUE CONSTRAINTS

=head2 C<distribution>

=over 4

=item * L</distribution>

=back

=cut

__PACKAGE__->add_unique_constraint("distribution", ["distribution"]);

=head1 RELATIONS

=head2 alert_histories

Type: has_many

Related object: L<CPANMonitor::Schema::Result::AlertHistory>

=cut

__PACKAGE__->has_many(
  "alert_histories",
  "CPANMonitor::Schema::Result::AlertHistory",
  { "foreign.alert" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

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


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-04-23 19:04:20
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jSvE9oYT2kgP2vF93nWS8Q

use Email::MIME::Kit;
use Email::Sender::Simple qw(sendmail);
use MetaCPAN::API;
use DateTime::Format::RFC3339;

sub update_from_api
{
	my $self = shift;

	my $api = MetaCPAN::API->new;
	
	eval {
		my $nice_dist = $self->distribution;
		
		$nice_dist =~ s/::/-/g;
		
		my $distribution = $api->release( distribution => $nice_dist );

		if ( $self->version ne $distribution->{ version } )
		{
			# copy to history
			
			$self->alert_histories->create( { alert => $self->id, version => $self->version, released => $self->released } );
			
			$self->updated( DateTime->now( time_zone => 'Europe/London' ) );

			# send the email
			
			foreach my $user_alert ( $self->user_alerts )
			{
				my $kit = Email::MIME::Kit->new( { source => 'mkits/alert.mkit' } );
 
				my $email = $kit->assemble( { distribution => $distribution } );

				sendmail( $email, { to => [ $user_alert->email ] } );
			}
		}

		$self->update_with_distribution( $distribution );
	};
	
	warn $@ if $@;

	return $self;
}

sub update_with_distribution
{
	my ( $self, $distribution ) = @_;
	
	$self->abstract( $distribution->{ abstract } );
	$self->author(   $distribution->{ author }   );
	$self->version(  $distribution->{ version }  );
			
	$self->released( DateTime::Format::RFC3339->parse_datetime( $distribution->{ date }.'Z' ) );
	
	$self->checked( DateTime->now( time_zone => 'Europe/London' ) );

	$self->update;

	return $self;
}
# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
