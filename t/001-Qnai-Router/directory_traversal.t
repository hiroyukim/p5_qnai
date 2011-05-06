use strict;
use warnings;
use Test::More;
use Qnai::Router;

subtest '/' => sub {
    ok( not Qnai::Router->is_directory_traversal('/') );
    done_testing();
};

subtest '/../hoge' => sub {
    ok( Qnai::Router->is_directory_traversal('/../hoge') );
    done_testing();
};

subtest '/./hoge' => sub {
    ok( Qnai::Router->is_directory_traversal('/./hoge') );
    done_testing();
};

done_testing();
