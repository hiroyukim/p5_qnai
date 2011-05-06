use strict;
use warnings;
use utf8;
use TTApp;

my $app = sub {
    TTApp->new(shift)->run();
};
