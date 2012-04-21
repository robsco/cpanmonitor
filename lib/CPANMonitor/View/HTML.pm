package CPANMonitor::View::HTML;

use strict;
use warnings;

use base 'Catalyst::View::TT';

use Time::HiRes qw( gettimeofday );

__PACKAGE__->config(

	TEMPLATE_EXTENSION => '.tt',
	render_die => 1,
	TIMER   => 1,
	expose_methods => [ 'took' ],
	
);

sub took
{
	my ( $self, $c, $string ) = @_;

	if ( exists $c->stash->{ started } )
	{
		return sprintf( "%.5f", gettimeofday() - $c->stash->{ started } );
	}
	
	return '-';
}

=head1 NAME

CPANMonitor::View::HTML - TT View for CPANMonitor

=head1 DESCRIPTION

TT View for CPANMonitor.

=head1 SEE ALSO

L<CPANMonitor>

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
