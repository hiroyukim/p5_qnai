use inc::Module::Install;
name 'Qnai';
all_from 'lib/Qnai.pm';

requires 'Text::Xslate';
requires 'Class::Load';
requires 'Sub::Name';
requires 'Try::Tiny';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
