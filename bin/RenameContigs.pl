#!/usr/local/bin/perl -w
# RenameContigs.pl
# Geoffrey Hannigan
# Elizabeth Grice Lab
# University of Pennsylvania
# Created: 2014-12-09

# This script is to be used to rename the contig fasta files by assigning the contigs numeric IDs in progression.

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

my $number = 0;

while (my $line = <IN>) {
	#If the line is a fasta sequence title, rename it with a sequential numeric ID.
	if ($line =~ /\>/) {
		print OUT ">_";
		# Add leading zeros to the contig IDs.
		printf OUT ("%08d",$number); 
		print OUT "\n";
		++$number;
	}
	else {
		print OUT $line;
	}
}

#Close out files and print completion note to STDOUT
close(IN);
close(OUT);
print "Contigs have been successfully renamed.\n"




