package Qnai::View::Factory;
use strict;
use warnings;
use Class::Load ':all';

sub create {
    my ($class,$view_class,$init_data) = @_;

    $view_class ||= 'Qnai::View::TX';

    load_class($view_class);

    $view_class->new($init_data);
}


1;
__END__

=head1 NAME

    Qnai::View::Factory

=head1 SYNOPSIS

    use Qnai::View::Factory;

    my $obj = Qnai::View::Factory->create('Qnai::View::TX');

=head1 AUTHOR

    hiroyukim
