package CPANMonitor::Controller::Feed;

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
=head1 METHODS

=cut

sub rss :Chained( '/' ) PathPart( 'rss' ) Args(1)
{
	my ( $self, $c, $user_id ) = @_;

	$c->log->trace( '' );

	my @alerts = $c->model( 'DB::User' )->find( { id => $user_id } )->user_alerts->all;
	
	my @entries = ();

	my $api = MetaCPAN::API->new;
	
	foreach my $alert ( @alerts )
	{
		#my $distribution = $api->release( distribution => $alert->alert->distribution );

		push @entries, { title => $alert->alert->distribution };
	}

	#$c->log->trace( $api->fetch( 'release/_search?Moose' ) );

	$c->stash->{feed} = { format      => 'RSS 2.0',
    id          => $c->req->base,
    title       => 'My Great Site',
    description => 'Kitten pictures for the masses',
    link        => $c->req->base,
    modified    => DateTime->now,
    entries => \@entries,
};
	
	$c->forward('View::Feed');
}


=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
