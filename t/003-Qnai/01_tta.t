use strict;
use warnings;
use t::Util;

$ENV{PLACK_ENV} = 'development';

run_app_test('TTApp');

