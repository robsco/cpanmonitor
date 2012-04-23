package CPANMonitor::Controller::Monitor;

use Moose;
use namespace::autoclean;

use CPANMonitor::Form::Search;
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

	$c->log->trace( "In Monitor->base");

}

sub index :Chained('base') :PathPart('') :Args(0)
{
	my ( $self, $c ) = @_;

	$c->log->trace( "In Monitor->index");

	$c->response->redirect( $c->uri_for_action( '/monitor/list' ) );
	$c->detach;
}

sub list :Chained('base') :PathPart('list') :Args(0)
{
	my ( $self, $c ) = @_;

	$c->log->trace( "In Monitor->list");

	my @user_alerts = $c->user->user_alerts->search( {}, { join => 'alert', order_by => { -asc => 'alert.distribution' } } )->all;

	$c->stash( template => 'monitor/list.tt', user_alerts => \@user_alerts );
}

sub search :Chained('base') :PathPart('search') :Args(0)
{
	my ( $self, $c ) = @_;

	$c->log->trace( "In Monitor->search");

	my $form = CPANMonitor::Form::Search->new;

	my @matches = ();
	
	if ( $c->req->param )
	{
		$form->process( params => $c->request->params );

		if ( $form->validated )
		{
			my $mcpan = MetaCPAN::API->new;

			my $dist = $form->field('distribution')->value;
			
			$dist =~ s/::/-/g;
			
			my $search   = $mcpan->release( search => { q => $dist .' AND status:latest', fields => 'distribution,version' } );

			@matches = map { $_->{ fields } } @{ $search->{ hits }->{ hits } };
		}
	}		

	$c->stash( template => 'monitor/search.tt', form => $form, matches => \@matches );
}

sub add :Chained('base') :PathPart('add') :Args(0)
{
	my ( $self, $c ) = @_;

	$c->log->trace( "In Monitor->add");

	my $form = CPANMonitor::Form::Alert->new;

	if ( ! $c->req->param )
	{
		$form->process( init_object => { email => $c->user->email } );
	}
	else
	{
		if ( $c->req->method eq 'GET' )
		{
			my $init_object = { email => $c->user->email };

			if ( my $dist = $c->req->params->{ distribution } )
			{
				$dist =~ s/-/::/g;
				
				$init_object->{ distribution } = $dist;
			}
			
			$form->process( init_object => $init_object );
		}
		else
		{	
			$form->process( params => $c->request->params );
	
			if ( $form->validated )
			{
				# make sure it's valid

				my $api = MetaCPAN::API->new;

				my $name = $form->field('distribution')->value;		
				
				$name =~ s/::/-/g;
			
				my $distribution;
				
				eval {
					$c->log->trace( "Looking up " . $name );

					$distribution = $api->release( distribution => $name );

					$c->log->trace( "PACKAGE:" , $distribution );
				};
			
				$c->log->warn( $@ );

				if ( $@ )
				{
					$form->field('distribution')->add_error( "Unable to find that distribution" );
				}
				else
				{
					my $alert = $c->model('DB::Alert')->find_or_create( { distribution => $form->field('distribution')->value }, { key => 'distribution' } );

					$alert->update_from_api;
				
					my $user_alert = $c->model('DB::UserAlert')->find_or_create( { user => $c->user->id, alert => $alert->id, email => $form->field('email')->value }, { key => 'user_alert_email' } );
	
					$user_alert->development( $form->field('development')->value );
				
					$user_alert->update;

					$c->log->trace("Redirecting to /monitor/list");
				
			 		$c->response->redirect( $c->uri_for( $self->action_for( '/monitor/list' ), { mid => $c->set_status_msg("alert added") } ) );
			 		$c->detach;
			 	}
			}
		}
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
