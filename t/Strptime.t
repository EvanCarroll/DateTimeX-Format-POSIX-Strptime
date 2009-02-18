package main;
use DateTimeX::Format::POSIX::Strptime;
use Test::More tests=>3;

use feature ':5.10';

is(
	DateTimeX::Format::POSIX::Strptime->new({
		pattern => "%d%b%y"
		, timezone => 'America/Chicago'
		, locale => 'en_US'
	})->parse_datetime( "05AUG11" )->ymd
	, '2011-08-05'
	, "Got the right value for pattern %d%b%y"
);

is(
	DateTimeX::Format::POSIX::Strptime->new({
		pattern => "%d%b%Y"
		, timezone => 'America/Chicago'
		, locale => 'en_US'
	})->parse_datetime( "05AUG0440" )->ymd
	, '0440-08-05'
	, "Got the right value for pattern %d%b%Y"
);

is(
	DateTimeX::Format::POSIX::Strptime->new(
		pattern     => '%T'
		, locale    => 'en_AU'
		, timezone  => 'Australia/Melbourne'
	)->parse_datetime('23:16:42')->hms
	, '23:16:42'
	, "Got the right value for pattern %T"
);
