use strict;
use warnings;
use Test::More;
use Qnai::Router::Rule;

my $rules = [
    {
        pattern => '/',
        code    => sub {
            my $self = shift;

            return 1;
        },
        template => '/root/index.html',
    },
];

my $router = Qnai::Router::Rule->new();

subtest 'include system_template' => sub {
    cmp_ok( $rules->[0], 'cmp', $router->system_template->[0] );
    done_testing();
};

done_testing();
