use strict;
use warnings;

use CPANMonitor;

my $app = CPANMonitor->apply_default_middlewares(CPANMonitor->psgi_app);
$app;

