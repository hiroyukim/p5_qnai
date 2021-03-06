package Qnai;
use strict;
use warnings;
use base 'Class::Accessor::Fast';
our $VERSION = '0.01';
use Qnai::Request;
use Qnai::Response;
use Qnai::Router;
use Qnai::View::Factory;
use Qnai::Router::Rule;
use Try::Tiny;
use Carp ();

__PACKAGE__->mk_accessors(qw/env stash req/);

my $config = {};
my $rules  = [];
my $router = undef;

sub import {
    my $class  = shift;
    my $caller = caller();
   
    {
        no strict 'refs';
        push @{"$caller\::ISA"},$class;
    }

    for my $func ( qw(rule config register_prepare) ) {
        my $code = $class->can($func);
        no strict 'refs'; ## no critic.
        *{"$caller\::$func"} = sub { $code->($caller,@_) }; 
    }
}

sub rule {
    my ($self,$pattern,$code,$template) = @_;

    push @{$rules},Qnai::Router::Rule->new({
        pattern => $pattern,
        code     => $code,
        template => $template||undef,
    });
}

sub router { 
    my $self = shift;
    Qnai::Router->new($self->config->{template_path} => $rules => $self->config->{router_option}) 
}

sub register_dispatch {
    my ($self,$rule) = @_;
    my $class = ref($self);

    my $subname = join('_','dispatch',(split(/\//,$rule->pattern)));

    no strict 'refs';
    no warnings 'redefine';
    *{"${class}::${subname}"} = $rule->code;

    return $subname;
}

sub response {
    my $self   = shift;
    Qnai::Response->new(@_,$self->encoding())->finalize();
}

sub register_prepare {
    my ($class,$code) = @_;

    no strict 'refs';
    no warnings 'redefine';
    *{"${class}::prepare"} = $code;
}

sub config {
    my ($self,$args) = @_;

    if( ref($args) eq 'HASH' ) {
        $config =$args;
    }
    return $config;
}

sub new {
    my ($class,$env,$args) = @_;

    bless { 
        env    => $env,
        stash  => {}, 
        req    => Qnai::Request->new($env => $class->encoding),
    }, $class; 
}

sub encoding {
    my $self     = shift;
    my $encoding = shift;
    return $encoding || $self->config->{encoding};
}

sub view {
    my $self       = shift;
    my $view_class = shift || 'Qnai::View::TX';
    Qnai::View::Factory->create($view_class,$self->config->{view});
}

sub run {
    my $self = shift;


    try {
        $self->prepare();

        if( my $match_rule = $self->router->match($self->env) ) {
            if( $match_rule->template ) {
                $self->{template} = $match_rule->template;
            }
            if( $match_rule->code ) {
                my $subname = $self->register_dispatch($match_rule);
                $self->$subname();
            }
        }
        else {
            Qnai::Exception::HTTP::NotFound->throw();
        }
    }
    catch {
        my $err = $_; 
        Carp::confess($err);
    };

    my $content = $self->view->render(
        $self->{template},
        {
            config => $self->config,
            req    => $self->req,
            %{$self->stash},
        },
    );

    return $self->response(
        200,
        ['Content-type' => 'text/html'],
        $content,
    );
}

1;
__END__

=head1 NAME

Qnai -

=head1 SYNOPSIS

    package YourModule;
    use strict;
    use warnings;
    use utf8;
    use Qnai;
    use Cwd;

    config({
        view => {
            syntax => 'TTerse',
            path   => [dir(cwd(),'template')], 
        },
    });

    rule('/' => sub {
        my $self = shift;
    },{
        template => '/root/index.html',
    });
    
    rule('api/:year/:month' => sub {
        #.......   
    });

    # other default
    
    prepare {

    };

    end {

    };

    1;

    # app.psgi
    
    my $app = sub {
        my $env = shift;
        YourModule->new($env)->run();
    };

=head1 DESCRIPTION

Qnai is

=head1 AUTHOR

E<lt>hiroyukimm {at} gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
