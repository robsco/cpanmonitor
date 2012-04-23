#!/usr/bin/perl -w

use strict;
use warnings;

use Data::Dumper;

use CPANMonitor::Schema;

my $schema = CPANMonitor::Schema->connect( 'dbi:mysql:cpanmonitor_dev', 'cpanmonitor_dev', 'cpanmonitor_dev' );

my @alerts = $schema->resultset('Alert')->all;

foreach my $alert ( @alerts )
{
	$alert->update_from_api;
}


