use strict;
use warnings;
use Test::More;


use Catalyst::Test 'EMS';
use EMS::Controller::Admin::Pages;

ok( request('/admin/pages')->is_success, 'Request should succeed' );
done_testing();
