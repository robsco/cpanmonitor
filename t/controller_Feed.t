use strict;
use warnings;
use Test::More;


use Catalyst::Test 'CPANMonitor';
use CPANMonitor::Controller::Feed;

ok( request('/feed')->is_success, 'Request should succeed' );
done_testing();
