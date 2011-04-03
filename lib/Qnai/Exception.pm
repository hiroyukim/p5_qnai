package Qnai::Exception;
use strict;
use warnings;
use Carp ();

sub throw {
    my $class = shift;
    my $args  = shift; 
    Carp::crop($args);
}

package Qnai::Exception:HTTP;
use base 'Qnai::Exception';

1;
