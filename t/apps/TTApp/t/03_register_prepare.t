use strict;
use warnings;
use Plack::Test;
use Plack::Util;
use Test::More;

my $app = Plack::Util::load_psgi 'TTApp.psgi';

test_psgi
    app => $app,
    client => sub {
        my $cb = shift;
        my $req = HTTP::Request->new(GET => 'http://localhost/register_prepare');
        my $res = $cb->($req);
        is $res->code, 200;
        diag $res->content if $res->code != 200;
        like $res->content, qr/register_prepare/;
    };

done_testing;

