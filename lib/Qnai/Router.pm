package Qnai::Router;
use strict;
use warnings;
use base qw/Class::Accessor::Fast/;
use Router::Simple;

__PACKAGE__->mk_accessors(qw/rules router_simple/);

sub new {
    my ($class,$rules) = @_;

    my $self = bless {
        rules         => $rules, 
        router_simple => Router::Simple->new,
    }, $class;

    $self->_init();

    return $self;
}

sub _init {
    my $self = shift;

    for my $rule ( @{$self->rules} ) {
        $self->router_simple->connect(
            $rule->{pattern} => {
                pattern   => $rule->{pattern},
                code      => $rule->{code},
                opt       => $rule->{opt},
            }
        );
    }
}

sub match {
    my $self = shift;
    my $env  = shift;
    my $match_rule = $self->router_simple->match($env);

    if( $match_rule ) {
        return $match_rule;
    }
    else {
        # default
    }
}

1;
