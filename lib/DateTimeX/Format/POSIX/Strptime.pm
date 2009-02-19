package DateTimeX::Format::POSIX::Strptime;
use strict;
use warnings;

our $VERSION = '00.01_02';

use feature ':5.10';
use mro 'c3';
use 5.010;

use Moose;
use Carp;

with 'DateTimeX::Format::CustomPattern';
with 'DateTimeX::Format';

use POSIX::strptime;
use POSIX qw();

sub parse_datetime {
	my ( $self, $time, $args ) = @_;
	my $pattern  = $args->{pattern};
	my $timezone = $args->{timezone};
	my $locale   = $args->{locale};
	
	if ( $pattern =~ m/%([cxX])/ ) {
		my $cldr;
		if ( $1 eq 'c' ) {
			$cldr = $self->locale->datetime_format_default
		}
		elsif ( $1 eq 'x' ) {
			$cldr = $self->locale->date_format_default
		}
		elsif ( $1 eq 'X' ) {
			$cldr = $self->locale->time_format_default
		}
		Class::MOP::load_class( 'DateTime::Format::CLDR' );
	
		my $dt = DateTime::Format::CLDR->new(
			pattern     => $cldr
			, locale    => $locale
			, time_zone => $timezone
			, on_error  => 'croak'
		)->parse_datetime( $time );
	}
	my @time = POSIX::strptime($time,$pattern);

	## Day and month are 1-based
	$time[4] += 1;

	## Year is +=1900
	$time[5] += 1900 if defined $time[5];

	$self->new_datetime({
		timezone  => $timezone
		, locale  => $locale
		, second  => $time[0]
		, minute  => $time[1]
		, hour    => $time[2]
		, day     => $time[3]
		, month   => $time[4]
		, year    => $time[5]
	});

}

sub format_datetime {
	my ( $self, $dt, $env ) = @_;

	my $pattern = $env->{pattern};
	$pattern //= $self->has_pattern
		? $self->pattern
		: croak 'No pattern to format object with'
	;

	$dt->strftime( $pattern );
}

1;

no Moose;
__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

DateTimeX::Format::POSIX::Strptime - OO interface into the POSIX library's strptime

=head1 SYNOPSIS

	use DateTimeX::Format::Strptime;

	my $dtf = DateTimeX::Format::Strptime({ locale => 'en_US', timezone => 'America/Chicago', pattern => $pattern });

	$dtf->parse_datetime( "time" );

	$dtf->pattern( $newPattern );

	## Call-only pattern won't be cached
	$dtf->parse_datetime( "time", { pattern => $pattern } );

	$dtf->format_datetime( $dt, $pattern );

=head1 DESCRIPTION

This module does *not* reimpliment strptime(3) into perl. It binds into the POSIX library using L<POSIX::strptime> and uses Moose for the rest. This is massively simplier and less error-prone than L<DateTime::Format::Strptime> which is an attempt at a total perl implimentation of POSIX strptime(3).

This module differs from L<DateTime::Format::Strptime> in a few ways: (a) it deosn't have complex PrintError/RaiseError code, it simply dies if it has reason to believe there was an error; (b) it doesn't have complex diagnostic code, and it doesn't really need it either: the work is in the POSIX library not perl; (c) it has all of the advantages of the L<DateTimeX::Format>, and L<DateTimeX::Format::CustomPattern> roles.

=head1 CONSTRUCTOR AND METHODS

See the two accompanying roles L<DateTimeX::Format>, and L<DateTimeX::Format::CustomPattern> which provide the constructor, and details about the how the methods B<parse_datetime> and B<format_datetime> work.

=head1 AUTHOR

Evan Carroll, C<< <me at evancarroll.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-datetimex-format-posix-strptime at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=DateTimeX-Format-POSIX-Strptime>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc DateTimeX::Format::POSIX::Strptime

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=DateTimeX-Format-POSIX-Strptime>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/DateTimeX-Format-POSIX-Strptime>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/DateTimeX-Format-POSIX-Strptime>

=item * Search CPAN

L<http://search.cpan.org/dist/DateTimeX-Format-POSIX-Strptime/>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2009 Evan Carroll, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
