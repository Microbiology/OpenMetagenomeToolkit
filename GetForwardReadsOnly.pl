#!/usr/bin/perl
# GetForwardReadsOnly.pl
# Geoffrey Hannigan
# Pat Schloss Lab
# University of Michigan

# Use this simple script to pull out only the
# forward reads of a fasta file

# Set use
use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;

# Set variables
my $line;
my $flag = 0;
my $input;
my $output;

# Set the options
GetOptions(
    'i|input=s' => \$input,
    'o|output=s' => \$output
);

# Open the files
open(IN, "<$input") || die "Unable to open $input: $!";
open(OUT, ">$output") || die "Unable to write to $output: $!";

while (my $line = <IN>) {
    chomp $line;
    if ($line =~ /\>.+\s2:/) {
	print OUT "$line\n";
	$flag =1;
    } elsif ($flag == 1) {
	print OUT "$line\n";
	$flag = 0;
    } else {
	next;
    }
}

print STDERR "Process complete.\n";
