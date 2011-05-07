use inc::Module::Install;
use Module::Install::Repository;
use Module::Install::AuthorTests;

name 'Qnai';
all_from 'lib/Qnai.pm';
license 'perl';

requires 'Text::Xslate';
requires 'Class::Load';
requires 'Sub::Name';
requires 'Try::Tiny';
requires 'Class::Accessor::Fast';
requires 'Test::More'                => 0.88;
requires 'Router::Simple'            => 0.02;

tests 't/*.t t/*/*.t t/*/*/*.t';
recursive_author_tests('xt');

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
