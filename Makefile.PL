use inc::Module::Install;

name     'DateTimeX-Format-POSIX-Strptime';
all_from 'lib/DateTimeX/Format/POSIX/Strptime.pm';
author   'Evan Carroll <me@evancarroll.com>';
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

