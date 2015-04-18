use strict;
use warnings;
use Test::More;


use Catalyst::Test 'EMS';
use EMS::Controller::Admin::Users;

ok( request('/admin/users')->is_success, 'Request should succeed' );
done_testing();
