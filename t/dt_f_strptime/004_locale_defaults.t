#!perl -w

# t/004_locale_defaults.t - check module dates in various formats

use Test::More tests => 48;
use DateTimeX::Format::POSIX::Strptime;

my $object = DateTimeX::Format::POSIX::Strptime->new(
	pattern => '%c',
	diagnostic => 0,
);

my @tests = (
	# Australian English
	['en_AU',	'%x',	'31/12/1998'],
	['en_AU',	'%X',	'12:34:56 PM'],
	['en_AU',	'%c',	'31/12/1998 12:34:56 PM'],
	# US English
	['en_US',	'%x',	'Dec 31, 1998'],
	['en_US',	'%X',	'12:34:56 PM'],
	['en_US',	'%c',	'Dec 31, 1998 12:34:56 PM'],
	# UK English
	['en_GB',	'%x',	'31 Dec 1998'],
	['en_GB',	'%X',	'12:34:56 PM'],
	['en_GB',	'%c',	'31 Dec 1998 12:34:56'],
	# French
#);my @tests = (
	['fr',	'%x',	'31 d�c 1998'],
	['fr',	'%X',	'12:34:56'],
	['fr',	'%c',	'31 d�c 1998 12:34:56'],
);

foreach (@tests) {
	my ($locale, $pattern, $data) = @$_;
	$object->locale($locale);
	$object->pattern($pattern);
	my $datetime = $object->parse_datetime( $data );

	if ($pattern eq '%x' or $pattern eq '%c') {
		is($datetime->year,  1998, $locale. ' : ' . $pattern . ' : year'  );
		is($datetime->month,   12, $locale. ' : ' . $pattern . ' : month' );
		is($datetime->day,     31, $locale. ' : ' . $pattern . ' : day'   );
	}
	if ($pattern eq '%X' or $pattern eq '%c') {
		is($datetime->hour,    12, $locale. ' : ' . $pattern . ' : hour'  );
		is($datetime->minute,  34, $locale. ' : ' . $pattern . ' : minute');
		is($datetime->second,  56, $locale. ' : ' . $pattern . ' : second');
	}
}


