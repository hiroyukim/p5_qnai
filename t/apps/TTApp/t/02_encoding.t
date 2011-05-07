use strict;
use warnings;
use utf8;
use Plack::Test;
use Plack::Util;
use Test::More;

my $app = Plack::Util::load_psgi 'TTApp.psgi';

test_psgi
    app => $app,
    client => sub {
        my $cb = shift;
        my $req = HTTP::Request->new(GET => 'http://localhost/endocding');
        my $res = $cb->($req);
        is $res->code, 200;
        diag $res->content if $res->code != 200;
        like $res->decoded_content, qr/こんにちわ/;
    };

done_testing;

