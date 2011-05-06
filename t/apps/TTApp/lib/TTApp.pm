package TTApp;
use strict;
use warnings;
use utf8;
our $VERSION = '0.01';
use Qnai;
use Path::Class;
use Cwd;

config({
    template_path => dir( cwd() ,'template' )->stringify,
    view => {
        syntax => 'TTerse',
        path   => [dir(cwd(),'template')->stringify],
    },
});

rule('/' => sub {
    my $self = shift;

    $self->stash->{hoge} = 'hello';

} => '/root/index.html');

1;
