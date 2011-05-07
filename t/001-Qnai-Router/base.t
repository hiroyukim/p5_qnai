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
    Qnai::Router::Rule->new({
        pattern => '/hoge',
        code    => sub {
            my $self = shift;

            return 1;
        },
        template => '/root/index.html',
    }),
];

my $template_path = './template/'; 

my $router = Qnai::Router->new( $template_path => $rules => { ignore_auto_template => 'include' } );

ok $router;

subtest 'include system_template' => sub {
    cmp_ok( $rules->[0], 'cmp', $router->system_template->[0] );
    done_testing();
};

subtest 'ignore_auto_tempalte' => sub {
    ok($router->is_ignore_auto_template('/include/header.html') );
    done_testing();
};

subtest 'match /' => sub {
    ok $router->match({ PATH_INFO => '/' });
    done_testing();
};

subtest 'parse_path /hoge' => sub {
    my ($dir,$file) = $router->parse_path('/hoge');
    cmp_ok( $dir->[0],  'eq', 'root' ); 
    cmp_ok( $file, 'eq', 'hoge'  ); 
    done_testing();
};

subtest 'parse_path /user/edit' => sub {
    my ($dir,$file) = $router->parse_path('/user/edit');
    cmp_ok( $dir->[0],  'eq', 'user' ); 
    cmp_ok( $file, 'eq', 'edit'  ); 
    done_testing();
};

subtest 'parse_path /user/edit' => sub {
    my ($dir,$file) = $router->parse_path('/user/edit.html');
    cmp_ok( $dir->[0],  'eq', 'user' ); 
    cmp_ok( $file, 'eq', 'edit'  ); 
    done_testing();
};

subtest 'parse_path /hoge/hoge/hoge/hoge/' => sub {
    my ($dir,$file) = $router->parse_path('/hoge/hoge/hoge/hoge/');
    cmp_ok( join('/',@$dir), 'eq', 'hoge/hoge/hoge/hoge' ); 
    cmp_ok( $file, 'eq', 'index'  ); 
    done_testing();
};

subtest 'parse_path /' => sub {
    my ($dir,$file) = $router->parse_path('/');
    cmp_ok( $dir->[0],  'eq', 'root' ); 
    cmp_ok( $file, 'eq', 'index'  ); 
    done_testing();
};

done_testing();
