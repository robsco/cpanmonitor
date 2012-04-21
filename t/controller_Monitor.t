use strict;
use warnings;
use Test::More;


use Catalyst::Test 'CPANMonitor';
use CPANMonitor::Controller::Monitor;

ok( request('/monitor')->is_success, 'Request should succeed' );
done_testing();
