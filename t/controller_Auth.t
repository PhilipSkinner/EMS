use strict;
use warnings;
use Test::More;


use Catalyst::Test 'EMS';
use EMS::Controller::Auth;

ok( request('/auth')->is_success, 'Request should succeed' );
done_testing();
