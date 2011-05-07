package Qnai::Exception;
use strict;
use warnings;
use Carp ();

sub throw {
    my $class = shift;
    my $args  = shift; 
    Carp::croak($args);
}

package Qnai::Exception::HTTP;
use base 'Qnai::Exception';

package Qnai::Exception::HTTP::NotFound;
use base 'Qnai::Exception';

package Qnai::Exception::FileNotFound;
use base 'Qnai::Exception';

package Qnai::Exception::SystemTemplate;
use base 'Qnai::Exception';

package Qnai::Exception::DirectoryTraversal;
use base 'Qnai::Exception';

package Qnai::Exception::IgnoreTemplate;
use base 'Qnai::Exception';

1;
