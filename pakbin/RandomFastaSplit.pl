#!/usr/bin/perl
# RandomFastaSplit.pl
# Geoffrey Hannigan
# Pat Schloss Lab
# University of Michigan

# Set use
use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
# Timer
my $start_run = time();

# Set variables
my %FastaHash;
my $opt_help;
my $input;
my $chosen;
my $remainder;
my $limit;
my $FastaErrorCounter = 0;
my $FastaID;
my $counter = 0;

# Set the options
GetOptions(
	'h|help' => \$opt_help,
	'i|input=s' => \$input,
	'c|chosen=s' => \$chosen,
	'r|remainder=s' => \$remainder,
	'l|limit=s' => \$limit
);

pod2usage(-verbose => 1) && exit if defined $opt_help;

open(IN, "<$input") || die "Unable to read $input: $!";
open(CHOSEN, ">$chosen") || die "Unable to write to $chosen: $!";
open(REMAINDER, ">$remainder") || die "Unable to write to $remainder: $!";

sub ReadInFasta {
	print STDERR "Progress: Reading in fasta...\n";
	# Set the variable for the fasta input file
	my $fastaInput = shift;
	# Setup fasta hash to return at the end
	while (my $line = <$fastaInput>) {
		if ($line =~ /\>/ && $FastaErrorCounter == 0) {
			# print "Made it to ID!\n";
			chomp $line;
			$FastaID = $line;
			# Get rid of the arrow from the ID
			$FastaID =~ s/\>//;
			$FastaID =~ s/_//g;
			$FastaErrorCounter = 1;
		} elsif ($line =~ /\>/ && $FastaErrorCounter == 1) {
			die "KILLED BY BAD FASTA! There was no sequence before ID $line: $!";
		} elsif ($line !~ /\>/ && $FastaErrorCounter == 0) {
			print STDERR "Yikes, is this in block format? That is totally not allowed!\n";
			die "KILLED BY BAD FASTA! There was a missing ID: $!";
		} elsif ($line !~ /\>/ && $FastaErrorCounter == 1) {
			chomp $line;
			# Change out the lower case letters so they match the codon hash
			$line =~ s/g/G/g;
			$line =~ s/a/A/g;
			$line =~ s/c/C/g;
			$line =~ s/t/T/g;
			$FastaHash{$FastaID} = $line;
			$FastaErrorCounter = 0;
		}
	}
	return %FastaHash;
}

sub PullFromRandomHash {
	# A hash structure is random, so everytime I iterate through,
	# I will go through the hash in a different order.
	print STDERR "Progress: Randomly splitting fasta...\n";
	my $fastaHash = shift;
	while (my ($fastaKey, $fastaSeq) = each(%{$fastaHash})) {
		if ($counter <= $limit) {
			print CHOSEN "\>$fastaKey\n$fastaSeq\n";
		} else {
			print REMAINDER "\>$fastaKey\n$fastaSeq\n";
		}
		++$counter;
	}
}

my %Fasta = ReadInFasta(\*IN);
# print Dumper \%Fasta;
PullFromRandomHash(\%Fasta);

close(IN);
close(CHOSEN);
close(REMAINDER);

my $end_run = time();
my $run_time = $end_run - $start_run;
print STDERR "Randomly split fasta in $run_time seconds.\n";

=head1 NAME

RandomFastaSplit.pl

=head1 SYNOPSIS

Given a fasta and the desired number of sequneces in the first file,
this script will randomly split the fasta into a fasta with the given
number of sequences, and a fasta with the remainder.

=head1 OPTIONS

CreateTableOfContents.pl 

	-f <input fastq>

	-c <output file for choven number>

	-r <output file for remaining sequences>

	-l <limit number>

=head1 ARGUMENTS

-h | --help	Print this helpful help menu.

-i | --input	Input fastq file to be trimmed

-c | --chosen	Output fasta of chosen number of sequences

-r | --remainder	Output fasta of the remaining sequences

-l | --limit	Limit of how many sequences to include in the chosen output file

=cut



