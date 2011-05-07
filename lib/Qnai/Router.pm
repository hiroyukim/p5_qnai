package Qnai::Router;
use strict;
use warnings;
use base qw/Class::Accessor::Fast/;
use Router::Simple;
use Params::Validate qw(:all);
use Qnai::Exception;
use Carp ();

__PACKAGE__->mk_accessors(qw/rules router_simple system_template template_path ext/);

sub new {
    my $class = shift;
    my ($template_path,$rules,$opt) = validate_pos(@_,
        { type => SCALAR   },
        { type => ARRAYREF },
        { type => HASHREF|UNDEF, optional => 1 },
    );

    Carp::Confess('please use Qnai::Router::Rule.') 
        unless( @$rules == grep { $_->isa('Qnai::Router::Rule') } @$rules);

    $opt ||= {};

    my $self = bless {
        rules           => $rules, 
        router_simple   => Router::Simple->new,
        system_template => [],
        template_path   => $template_path,
        ext             => $opt->{ext} || '.html',
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
    my $path_info = $env->{PATH_INFO};

    if( $self->is_directory_traversal($path_info) ) {
        Qnai::Exception::DirectoryTraversal->throw($path_info);
    }

    if( my $match_rule = $self->router_simple->match($env) ) {
        return Qnai::Router::Rule->new($match_rule);
    }
    else {
        if( $self->is_system_template($path_info) ) {
            Qnai::Exception::SystemTemplate->throw();
        }
        else {
            my ($dir,$file) = $self->parse_path($path_info);

            my $file_path = join('/','/',@$dir,$file . $self->ext() );
                        
            unless( -e join('/',$self->template_path,$file_path) ) {
                Qnai::Exception::FileNotFound->throw($file_path);
            }

            return Qnai::Router::Rule->new({
                pattern  => join('/','/',@$dir,$file ),
                code     => sub {},
                template => $file_path, 
            });
        } 
    }
}

sub is_directory_traversal {
    my ($self,$path) = @_;    
    ( $path =~ /^[\/a-z0-9_]+$/ig ) ? 0 : 1;
}

sub parse_path {
    my ($self,$path) = @_;
    my ( $dir,$file ) = $path =~ m{^/?([a-z0-9_/]*)/([^/.]*)\.?(.+)?$}i;
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
