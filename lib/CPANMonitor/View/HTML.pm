package CPANMonitor::View::HTML;

use strict;
use warnings;

use base 'Catalyst::View::TT';

use Time::HiRes qw( gettimeofday );

__PACKAGE__->config(

	TEMPLATE_EXTENSION => '.tt',
	render_die => 1,
	TIMER   => 1,
	expose_methods => [ 'format_date', 'took' ],
	
);

sub format_date
{
	my ( $self, $c, $dt ) = @_;
	
	return $dt ? $dt->strftime( '%FT%TZ' ) : '';
}

sub took
{
	my ( $self, $c ) = @_;

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
