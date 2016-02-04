#!/usr/bin/perl
# FilterFasta.pl
# Geoffrey Hannigan
# Pat Schloss Lab
# University of Michigan

# Set use
use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use Data::Dumper;
# And because I like timing myself
my $start_run = time();

# Set variables
my %FastaHash;
my @listArray;
my $fasta;
my $list;
my $output;
my $fastaInput;
my $line;
my $FastaID;
my $FastaErrorCounter = 0;
my $ListInput;
my $opt_help;
my $fastaSequence = 0;

# Set the options
GetOptions(
	'h|help' => \$opt_help,
	'f|fasta=s' => \$fasta,
	'l|list=s' => \$list,
	'o|output=s' => \$output
);

pod2usage(-verbose => 1) && exit if defined $opt_help;

open(FASTA, "<$fasta") || die "Unable to read $fasta: $!";
open(LIST, "<$list") || die "Unable to read $list: $!";
open(OUT, ">$output") || die "Unable to write to $output: $!";

# Read in the fasta file
sub ReadInFasta {
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

sub ReadInList {
	my $ListInput = shift;
	foreach my $line (<$ListInput>) {
		chomp $line;
		# Remove arrow from line
		$line =~ s/\>//;
		push @listArray, $line;
	}
	return @listArray;
}

sub SubsetFasta {
	my ($FastaHash, $listArray) = @_;
	foreach my $listLine (@listArray) {
		next unless /.*$listLine.*/ ~~ %FastaHash;
		my $listFull = $1 if /(.*$listLine.*)/ ~~ %FastaHash;
		# Pull out sequence from hash
		$fastaSequence = $FastaHash -> {$listFull};
		print OUT "\>$listFull\n$fastaSequence\n";
	}
}

my %Fasta = ReadInFasta(\*FASTA);
#print Dumper(\%Fasta);
my @List = ReadInList(\*LIST);
#print join("\n", @List);
SubsetFasta(\%Fasta, @List);

# How long did it take
my $end_run = time();
my $run_time = $end_run - $start_run;
print STDERR "Filtered fasta in $run_time seconds.\n";

=head1 NAME

FilterFasta.pl

=head1 SYNOPSIS

Given a list of sequence IDs (i.e. accession numbers), this script will
subset the input fasta to only include those sequences. Use this for
large files because it is faster than unix utilities.

=head1 OPTIONS

CreateTableOfContents.pl 
	-f <input fasta>
	-l <sequence id list> 
	-o <output file>

=head1 ARGUMENTS

-h | --help	Print this helpful help menu.

-f | --fasta	Input fasta file to be parsed

-l | --list List of sequence IDs to include in output. List is inclusive
			and does not assume exact matches.

-o | --output	Output fasta file to which sequences will be written to

=cut
