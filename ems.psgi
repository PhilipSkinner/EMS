use strict;
use warnings;

use EMS;

my $app = EMS->apply_default_middlewares(EMS->psgi_app);
$app;

