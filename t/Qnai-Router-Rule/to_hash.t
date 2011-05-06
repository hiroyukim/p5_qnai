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

my $router = Qnai::Router::Rule->new($rules->[0]);

subtest 'to_hash' => sub {
    ok( $router->to_hash->{pattern});
    ok( $router->to_hash->{code}   );
    ok( $router->to_hash->{template}   );
    done_testing();
};

done_testing();
