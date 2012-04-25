package CPANMonitor::View::HTML;

use strict;
use warnings;

use base 'Catalyst::View::TT';

use Time::HiRes qw( gettimeofday );

__PACKAGE__->config(

	TEMPLATE_EXTENSION => '.tt',
	render_die => 1,
	expose_methods => [ 'format_fuzzy_date', 'took' ],
	
);

sub format_fuzzy_date
{
	my ( $self, $c, $dt ) = @_;
	
	return $dt ? '<time datetime="' . $dt->strftime( '%FT%TZ' ) . '">' . $dt->strftime( '%d/%m/%y (%R)' ) . '</time>' : '';
}

sub took
{
	my ( $self, $c ) = @_;

	return exists $c->stash->{ started } ? sprintf( "%.5f", gettimeofday - $c->stash->{ started } ) : '-';
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