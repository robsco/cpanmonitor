package CPANMonitor::Controller::Monitor;

use Moose;
use namespace::autoclean;

use CPANMonitor::Form::Alert;

use MetaCPAN::API;
use Data::Dumper;
use DateTime;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

CPANMonitor::Controller::Monitor - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 base ( chained from /base )

Checks authentication.

=cut

sub base :Chained('/auth/authenticated') :PathPart('monitor') :CaptureArgs(0)
{
	my ( $self, $c ) = @_;

}




sub index :Chained('base') :PathPart('') :Args(0)
{
	my ( $self, $c ) = @_;

	$c->response->redirect( $c->uri_for_action( '/monitor/list' ) );
	return;
}


sub list :Chained('base') :PathPart('list') :Args(0)
{
	my ( $self, $c ) = @_;

	my @user_alerts = $c->user->user_alerts->all;

	$c->stash( template => 'monitor/list.tt', user_alerts => \@user_alerts );
}

sub add :Chained('base') :PathPart('add') :Args(0)
{
	my ( $self, $c ) = @_;

	my $form = CPANMonitor::Form::Alert->new;

	if ( $c->req->param )
	{
		$form->process( params => $c->request->params );

		if ( $form->validated )
		{
			# first check if the dist is already in the db
			
			my $alert = $c->model('DB::Alert')->search( { distribution => $form->field('distribution')->value }, {} )->single;
			
			if ( ! $alert )
			{
				$alert = $c->model('DB::Alert')->create( { distribution => $form->field('distribution')->value } );
			}
			
			# call MetaCPAN
			
			my $mcpan = MetaCPAN::API->new;			
			
			my $metacpan_dist = $alert->distribution;
			$metacpan_dist =~ s/::/-/g;
			
			my $distribution = {};
			
			eval {
				$distribution = $mcpan->release( distribution => $metacpan_dist );
				
				$alert->abstract( $distribution->{ abstract } );
				$alert->author( $distribution->{ author } );
				$alert->version( $distribution->{ version } );
				
				$alert->checked( DateTime->now( time_zone => 'Europe/London' ) );
				
				$alert->update;
			};

			my $user_alert = $c->model('DB::UserAlert')->create( { alert => $alert->id, development => $form->field('development')->value, user => $c->user->id, email => $form->field('email')->value, } );
						
		 	$c->response->redirect( $c->uri_for( $self->action_for( '/monitor/list' ), { mid => $c->set_status_msg("alert added") } ) );
		 	return;
		}
	}		
	else
	{
		$form->process( init_object => { email => $c->user->email } );
	}

	$c->stash( template => 'monitor/add.tt', form => $form );
}


=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
