package CPANMonitor::Controller::Root;

use Moose;
use namespace::autoclean;

use Time::HiRes qw(gettimeofday);

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

CPANMonitor::Controller::Root - Root Controller for CPANMonitor

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub base :Chained('/') :PathPart('') :CaptureArgs(0)
{
	my ( $self, $c ) = @_;

	$c->log->trace( "In Root->base");
	
	$c->stash( started => scalar( gettimeofday ) );
	
	$c->load_status_msgs;
}

sub index :Chained('base') :PathPart('') :Args(0)
{
	my ( $self, $c ) = @_;

	$c->log->trace( "In Root->index");

	$c->stash( template => 'index.tt' );

#	$c->log->debug("Homepage request redirecting to /monitor/index");
	
#	$c->response->redirect( $c->uri_for_action( '/monitor/index' ) );
#	$c->detach;
}

=head2 default

Standard 404 error page

=cut

sub default :Chained('base') :PathPart('') :Args
{
	my ( $self, $c ) = @_;

	$c->log->trace( "In Root->default");

	$c->log->debug("Page not found");
	
	$c->response->body( 'Page not found' );
	
	$c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Catalyst developer

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
