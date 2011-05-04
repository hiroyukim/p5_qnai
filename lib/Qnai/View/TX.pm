package Qnai::View::TX;
use strict;
use warnings;
use base 'Qnai::View::Base';
use Text::Xslate;

sub new {
    my ($class,$args) = @_;

    bless {
        tx => Text::Xslate->new($args),
    },$class;
}

sub render {
    my $self = shift;
    $self->{tx}->render(@_);
}

1;
