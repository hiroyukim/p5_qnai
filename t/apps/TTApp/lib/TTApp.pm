package TTApp;
use strict;
use warnings;
use utf8;
our $VERSION = '0.01';
use Qnai;
use Path::Class;
use Cwd;

config({
    encoding      => 'utf8',
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

rule('/endocding' => sub {
    my $self = shift;

    $self->stash->{hoge} = 'こんにちわ';

} => '/root/index.html');


register_prepare sub {
    my $self = shift;

    $self->stash->{hoge} = 'register_prepare';
};

rule('/register_prepare' => sub {
    my $self = shift;

} => '/root/index.html');



1;
