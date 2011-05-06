use inc::Module::Install;
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
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
