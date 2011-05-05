use strict;
use warnings;
use Test::More;
use Qnai::Router;
use Qnai::Router::Rule;

my $rules = [
    Qnai::Router::Rule->new({
        pattern => '/',
        code    => sub {
            my $self = shift;

            return 1;
        },
        template => '/root/index.html',
    }),
];

my $template_path = './template/'; 

my $router = Qnai::Router->new( $template_path => $rules );

ok $router;

subtest 'include system_template' => sub {
    cmp_ok( $rules->[0], 'cmp', $router->system_template->[0] );
    done_testing();
};

subtest 'match /' => sub {
    ok $router->match({ PATH_INFO => '/' });
    done_testing();
};

#subtest 'unmatch /hoge/' => sub { 
#    ok( not $router->match({ PATH_INFO => '/hoge/' }) );
#    done_testing();
#};

subtest 'parse_path /user/edit' => sub {
    my ($dir,$file) = $router->parse_path('/user/edit');
    cmp_ok( $dir->[0],  'eq', 'user' ); 
    cmp_ok( $file, 'eq', 'edit'  ); 
};

subtest 'parse_path /user/edit' => sub {
    my ($dir,$file) = $router->parse_path('/user/edit.html');
    cmp_ok( $dir->[0],  'eq', 'user' ); 
    cmp_ok( $file, 'eq', 'edit'  ); 
};

subtest 'parse_path /hoge/hoge/hoge/hoge/' => sub {
    my ($dir,$file) = $router->parse_path('/hoge/hoge/hoge/hoge/');
    cmp_ok( join('/',@$dir), 'eq', 'hoge/hoge/hoge/hoge' ); 
    cmp_ok( $file, 'eq', 'index'  ); 
};

subtest 'parse_path /' => sub {
    my ($dir,$file) = $router->parse_path('/');
    cmp_ok( $dir->[0],  'eq', 'root' ); 
    cmp_ok( $file, 'eq', 'index'  ); 
};

done_testing();
