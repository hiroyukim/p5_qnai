package Qnai::Router::Rule;
use strict;
use warnings;
use base qw/Class::Accessor::Fast/;
use Params::Validate qw(:all);

__PACKAGE__->mk_accessors(qw/pattern code template/);

sub new {
    my $class = shift;
    my %args  = validate(@_,{
        pattern  => { type => SCALAR                      },
        code     => { type => CODEREF                     },
        template => { type => SCALAR|UNDEF, optional => 1 },
    });
    
    bless \%args,$class;
}

sub to_hash {
    my $self = shift;
    return { map { $_ => ($self->$_ || undef) } qw/pattern code template/ };
}

1;
