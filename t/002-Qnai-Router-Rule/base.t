use strict;
use warnings;
use Test::More;
use Qnai::Router::Rule;

subtest 'init' => sub {
    my $router_rule = Qnai::Router::Rule->new(
        {
            pattern => '/',
            code    => sub {
                my $self = shift;

                return 1;
            },
            template => '/root/index.html',
        },
    );

    ok $router_rule;

    my $hash = $router_rule->to_hash;

    cmp_ok scalar(keys%$hash), '==', 3 ;
    cmp_ok $hash->{pattern}, 'eq', '/'; 
    cmp_ok $hash->{template},'eq', '/root/index.html'; 

    done_testing();
};

subtest 'undef template' => sub {
    my $router_rule = Qnai::Router::Rule->new(
        {
            pattern => '/',
            code    => sub {
                my $self = shift;

                return 1;
            },
        },
    );

    ok $router_rule;

    my $hash = $router_rule->to_hash;

    cmp_ok scalar(keys%$hash), '==', 3 ;
    cmp_ok $hash->{pattern}, 'eq', '/'; 
    ok( not $hash->{template} ); 

    done_testing();
};

done_testing();
