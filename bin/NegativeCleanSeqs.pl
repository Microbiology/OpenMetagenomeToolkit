#!/usr/local/bin/perl -w
# NegativeCleanSeqs.pl
# Geoffrey Hannigan
# Elizabeth Grice Lab
# University of Pennsylvania
# Created: 2015-02-26

# Notes
# THIS IS STILL A WORK IN PROGRESS
# Add function for converting fastq to fasta if needed
# WARNING: Makes tmp directory in the current working directory

# Set use
use strict;
use warnings;
use Cwd; # Module for getting working directory of the script
my $start_run = time();

# Set files to scalar variables
my $usage = "Usage: perl $0 <INFILE> <OUTFILE> <NEGFILE>";
my $infile = shift or die $usage;
my $outfile = shift or die $usage;
my $negfile = shift or die $usage;
open(IN, "<$infile") || die "Unable to open $infile: $!";
open(OUT, ">$outfile") || die "Unable to write to $outfile: $!";
open(NEG, "<$negfile") || die "Unable to write to $negfile: $!";

# Also set appropriate variables
my $randNum = int(rand(100000000));
my $cwd = getcwd(); # Get working directory path
my %refHash;
my %newHash;
my $value;
my $key;
my @negArray;
my $flag = 0;

# Print the working directory to std out
print STDERR "Working directory is ".$cwd."\n";
# Need to make a tmp directory for the intermediate files that will not be saved into memory
mkdir $cwd."/tmp";
mkdir $cwd."/tmp/".$randNum; # Make a directory for the results, within tmp

# Print progress to std out so that it is easier to keep track of what is going on at what times.
print STDERR "Blasting input file against NCBI non-redundant database...\n";
# Blast the fasta sequences from the file against the nt database (some of this will be hardcoded for now)
# Start by setting the blastn command as an array set of commands and running it in the system
my @cmd = ('blastn'); # Could specify the path here if needed
	push @cmd, '-query'; # Tabbing this out just because it is easier to read for me.
	push @cmd, $infile; # Set the input file as the query, and be sure to use the file name and not the contents.
	push @cmd, '-out';
	push @cmd, $cwd."/tmp/".$randNum."/blastnOutput1.txt"; # One of the results is a tmp file with a random number for a file name. This is going to be used again as a reference, and in the future I am going to want to write the name as an option for the user.
	push @cmd, '-db';
	push @cmd, '/project/egricelab/references/ncbi/nt';
	push @cmd, '-outfmt';
	push @cmd, '6';
	push @cmd, '-num_threads';
	push @cmd, '8';
	push @cmd, '-max_target_seqs';
	push @cmd, '1';
	push @cmd, '-evalue';
	push @cmd, '1e-3';
system(@cmd); # Finally run the function to get a tmp file with the blastn results

my $blastOut = $cwd."/tmp/".$randNum."/blastnOutput1.txt";
open(my $blastOutFH, "<", $blastOut) || die "Unable to open $blastOut: $!";

print STDERR "Blasting neg control file against NCBI non-redundant database...\n";

# Also run the blastn command on the negative control sequence file
my @cmdNeg = ('blastn'); # Could specify the path here if needed
	push @cmdNeg, '-query'; # Tabbing this out just because it is easier to read for me.
	push @cmdNeg, $negfile; # Set the input file as the query, and be sure to use the file name and not the contents.
	push @cmdNeg, '-out';
	push @cmdNeg, $cwd."/tmp/".$randNum."/blastnOutputNegative.txt"; # One of the results is a tmp file with a random number for a file name. This is going to be used again as a reference, and in the future I am going to want to write the name as an option for the user.
	push @cmdNeg, '-db';
	push @cmdNeg, '/project/egricelab/references/ncbi/nt';
	push @cmdNeg, '-outfmt';
	push @cmdNeg, '6';
	push @cmdNeg, '-num_threads';
	push @cmdNeg, '8';
	push @cmdNeg, '-max_target_seqs';
	push @cmdNeg, '1';
	push @cmdNeg, '-evalue';
	push @cmdNeg, '1e-3';
system(@cmdNeg); # Finally run the function to get a tmp file with the blastn results

my $blastOutNeg = $cwd."/tmp/".$randNum."/blastnOutputNegative.txt";
open(my $blastOutNegFH, "<", $blastOutNeg) || die "Unable to open $blastOutNeg: $!";

print STDERR "Annotating sequence names with appropriate gi numbers...\n";
# Next annotate the sequences with their corresponding gi numbers
while (my $line = <$blastOutFH>) {
	chomp $line;
	my ($key, $f2) = (split /\t/,$line)[0,1];
	$key = ">".$key;
	my $value = $1 if $f2 =~ m/^gi\|(\d+)\|.+/;
	$value = ">".$value;
	$refHash{$key}=$value;
}

print STDERR "Getting array of gi numbers included in negative control...\n";
# Get an array of gi numbers that are included in the negative control blast output
while (my $line = <$blastOutNegFH>) {
	chomp $line;
	my ($key, $f2) = (split /\t/,$line)[0,1];
	my $value = $1 if $f2 =~ m/^gi\|(\d+)\|.+/;
	$value = ">".$value;
	push (@negArray, $value);
}

# print STDERR "Printing the array for logging...\n";
# # Check the array
# print STDERR join(", ", @negArray)."\n";
# while ( ($key, $value) = each %refHash ) {
# 	print STDERR $key." -> ";
# 	print STDERR $refHash{$key}."\n";
# }

print STDERR "Creating new hash with only negative control matching elements...\n";
# Get only those hash elements with matching values between the negative cntrl and the sample
# Once this runs, we have a hash with only the sequence IDs with gi numbers shared with negative controls
while ( ($key, $value) = each %refHash ) {
	if (grep {$_ eq $value} @negArray) {
		$newHash{$key}=$value;
	} else {
		next;
	}
}

print STDERR "Removing negative control sequences...\n";
# Remove the sequences with IDs matching the hash keys by iterating through the input file and printing to OUT
while (my $line = <IN>) {
	chomp $line;
	if ($line =~ /\>/) {
		if (exists $refHash{$line}) {
			$flag = 1;
			print STDERR "Removed ID ".$line.".\n";
		} else {
			print OUT $line."\n";
			$flag = 0;
		}
	} else {
		if ($flag eq 0) {
			print OUT $line."\n";
		} elsif ($flag eq 1) {
			next;
		}
	}
}

# Get the toal time to run the script
my $end_run = time();
my $run_time = $end_run - $start_run;
my $runMinutes = $run_time / 60;
print STDERR "Negative controls have been removed for $infile in $runMinutes minutes.\n";

close(IN);
close(OUT);
close(NEG);
close($blastOutFH);
close($blastOutNegFH);

