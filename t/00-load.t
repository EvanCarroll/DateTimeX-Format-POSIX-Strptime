#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'DateTimeX::Format::POSIX::Strptime' );
}

diag( "Testing DateTimeX::Format::POSIX::Strptime $DateTimeX::Format::POSIX::Strptime::VERSION, Perl $], $^X" );
