#!/usr/local/bin/perl -w
# CalculateContigStats.pl
# Geoffrey Hannigan
# Elizabeth Grice Lab
# University of Pennsylvania
# Created: 2014-12-10

# This script can be used to calculate contig statistics for plotting, such as contig length and coverage.

# Set use
use strict;
use warnings;
# Use this module to use the ceiling function, which will round a digit up. This is needed for estimating the number of leading zeros required in the script.

# Set files to scalar variables
my $usage = "Usage: perl $0 <INFILE> <OUTFILE>";
my $infile = shift or die $usage;
my $outfile = shift or die $usage;
open(IN, "<$infile") || die "Unable to open $infile: $!";
open(OUT, ">$outfile") || die "Unable to write to $outfile: $!";

# Get the length of each contig within the file, in a tab delimited format.
# The first field should have the name of each contig, and the second field should have the length of each contig

while (my $line = <IN>) {
	if ($line =~ /\>/) {
		chomp $line;
		$line =~ s/\>//;
		print OUT "$line\t";
	} else {
		my $length = length($line);
		print OUT "$length\n";
	}
}

# Reset the input file location so I can loop from the beginning again.
seek IN, 0, 0;

#Close out files and print completion note to STDOUT
close(IN);
close(OUT);
print "Contigs stats have been calculated.\n"











