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

=cut

sub rss :Chained( '/' ) PathPart( 'rss' ) Args(0)
{
	my ( $self, $c ) = @_;

	$c->log->trace( '' );

	$c->stash->{feed} = {
    format      => 'RSS 1.0',
    id          => $c->req->base,
    title       => 'My Great Site',
    description => 'Kitten pictures for the masses',
    link        => $c->req->base,
    modified    => DateTime->now,
 
    entries => [
        {
            id       => $c->uri_for('rss', 'kitten_post')->as_string,
            link     => $c->uri_for('rss', 'kitten_post')->as_string,
            title    => 'First post!',
            modified => DateTime->now,
            content  => 'This is my first post!',
        },
        # ... more entries.
    ],
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
