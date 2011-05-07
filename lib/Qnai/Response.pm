package Qnai::Response;
use strict;
use warnings;
use base qw(Plack::Response);
use Carp ();
use Encode;

sub new {
    my($class, $rc, $headers, $content, $encoding) = @_;

    my $self = bless {}, $class;
    $self->status($rc)       if defined $rc;
    $self->headers($headers) if defined $headers;
    $self->body($content)    if defined $content;

    $self->{encoding} = $encoding or Carp::confess('need encoding'); 

    $self;
}

sub _body {
    my $self = shift;
    my $body = $self->body;
       $body = [] unless defined $body;

    if (!ref $body or Scalar::Util::blessed($body) && overload::Method($body, q("")) && !$body->can('getline')) {
        return [ Encode::encode($self->{encoding},$body) ];
    } else {
        return [ Encode::encode($self->{encoding},$body->[0]) ];
    }
}

1;
