package Qnai::Router;
use strict;
use warnings;
use base qw/Class::Accessor::Fast/;
use Router::Simple;
use Params::Validate qw(:all);
use Carp ();

__PACKAGE__->mk_accessors(qw/rules router_simple system_template/);

sub new {
    my $class = shift;
    my ($template_path,$rules) = validate_pos(@_,
        { type => SCALAR   },
        { type => ARRAYREF },
    );

    Carp::Confess('please use Qnai::Router::Rule.') 
        unless( @$rules == grep { $_->isa('Qnai::Router::Rule') } @$rules);

    my $self = bless {
        rules           => $rules, 
        router_simple   => Router::Simple->new,
        system_template => [],
        template_path   => $template_path,
    }, $class;

    $self->_init();

    return $self;
}

sub _init {
    my $self = shift;

    for my $rule ( @{$self->rules} ) {

        if( $rule->template ) {
            push @{$self->{system_template}},$rule->template;
        }

        $self->router_simple->connect(
            $rule->pattern => $rule->to_hash(), 
        );
    }
}

sub match {
    my $self = shift;
    my $env  = shift;

    if( $self->is_directory_traversal($env) ) {
        Qnai::Exception::DirectoryTraversal->throw();
    }

    my $match_rule = $self->router_simple->match($env);

    if( $match_rule ) {
        return $match_rule;
    }
    else {
        if( $self->is_system_template($env) ) {
            Qnai::Exception::SystemTemplate->throw();
        }
        else {
            my ($dir,$file) = $self->parse_path($env);

            my $template_path = join('/',$dir,$file);
        } 
    }
}

sub is_directory_traversal {
    my ($self,$path) = @_;    
    ( $path =~ /\.{1,2}/g )
}

sub parse_path {
    my ($self,$path) = @_;
    my ( $dir,$file ) = $path =~ m{^/([a-z0-9_/]*)/([^/]*)$}i;
    unless( $dir ) {
        $dir = 'root'; 
    }

    unless( $file ) {
        $file = 'index';
    }

    return ([split(/\//,$dir)],$file);
}

sub is_system_template {
    my $self = shift;
    my $template_path = shift;
    ( grep { $template_path eq $_ } @{$self->system_template} ) ? 1 : 0;
}

1;
