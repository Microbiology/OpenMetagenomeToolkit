#!/usr/local/bin/perl -w
# GlimmerPredict2Gff3.pl
# Geoffrey Hannigan
# Elizabeth Grice Lab
# University of Pennsylvania
# This script will take in a .predict file from glimmer and will convert it to gff3 format.

# Set use
use strict;
use warnings;

# Set files to scalar variables
my $usage = "Usage: perl $0 <INFILE> <CONTIGID> <OUTFILE>";
my $infile = shift or die $usage;
my $contigid = shift or die $usage;
my $outfile = shift or die $usage;
open(IN, "<$infile") || die "Unable to open $infile: $!";
open(OUT, ">$outfile") || die "Unable to write to $outfile: $!";

# Confirm the contig identification
print "Contig ID is $contigid.\n";

# Store flag value as zero
my $flag = 0;

while(my $line = <IN>) {
	# Once you hit the contig block of ORF interest, append to flag and get going!
	if ($flag==0) {
		if ($line =~ /\>$contigid\_/) {
			++$flag;
			next;
		} else {
			next;
		}
	# Now that the flag is appended, deal with the ORF lines for the contig of interest
	} if ($flag==1) {
		if ($line =~ /\>/) {
			# Once you hit the end of the ORFs of interest, by hitting the next contig identifier, append the flag.
			++$flag;
			next;
		} else {
			chomp $line;
			$line =~ s/\s+/\t/g;
			print OUT "$contigid\tGLIMMER\tgene\t";
			print OUT "$2\t$3\t$1\t$4\t$5\tID=$1\; NOTE\: Glimmer ORF prediction\;\n" if $line =~ /^(\S+)\t(\S+)\t(\S+)\t(\S)(\S)\t(\S+)/;
		}
	# Once the flag is appended for the last time, kill the loop. We are done here.
	} if ($flag==2) {
		last;
	}
}

#Close out files and print completion note to STDOUT
close(IN);
close(OUT);
print "Fin.\n";
