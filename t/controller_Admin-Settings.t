use strict;
use warnings;
use Test::More;


use Catalyst::Test 'EMS';
use EMS::Controller::Admin::Settings;

ok( request('/admin/settings')->is_success, 'Request should succeed' );
done_testing();
