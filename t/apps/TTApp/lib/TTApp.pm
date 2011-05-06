package TTApp;
use strict;
use warnings;
use utf8;
use Qnai;
use Path::Class;

config({
    view => {
        syntax => 'TTerse',
        path   => [dir(cwd(),'template')],
    },
});

rule('/' => sub {
    my $self = shift;

    $self->stash->{hoge} = 'hello';

} => '/root/index.html');

1;
