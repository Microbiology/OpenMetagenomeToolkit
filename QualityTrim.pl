#!/usr/bin/perl
# QualityTrim.pl
# Geoffrey Hannigan
# ViromeAnalysisToolkit

# Set use
use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
# Timer
my $start_run = time();

# Set variables
my %FastaHash;
my %QualityHash;
my $opt_help;
my $input;
my $output;
my $FastaID;
my $qualityString;
my $FastaErrorCounter=0;
my $fasta;
my $QualLength;
my $TrimmedSeq;
my $cutoff = 33;

# Set the options
GetOptions(
	'h|help' => \$opt_help,
	'i|input=s' => \$input,
	'o|output=s' => \$output,
	'c|cutoff=n' => \$cutoff
);

pod2usage(-verbose => 1) && exit if defined $opt_help;

# Set the cutoff value
$cutoff = $cutoff + 33;
my $firstNum = substr($cutoff, 0, 1);
my $secondNum = substr($cutoff, 1, 1);
my $RangeRegex = "[0-$firstNum][0-$secondNum]";

open(IN, "<$input") || die "Unable to read $input: $!";
open(OUT, ">$output") || die "Unable to write to $output: $!";

sub ReadInFastq {
	# Set the variable for the fasta input file
	my $fastaInput = shift;
	# Setup fasta hash to return at the end
	while (my $line = <$fastaInput>) {
		if ($line =~ /^\@/ && $FastaErrorCounter == 0) {
			# print "Made it to ID!\n";
			chomp $line;
			$FastaID = $line;
			# Get rid of the at from the ID
			$FastaID =~ s/^\@//;
			# Get rid of spaces
			$FastaID =~ s/\s/_/g;
			$FastaID =~ s/_//g;
			$FastaErrorCounter = 1;
			next;
		} elsif ($line =~ /^[ATGCatgc]/ && $FastaErrorCounter == 1) {
			chomp $line;
			# Change out the lower case letters so they match the codon hash
			$line =~ s/g/G/g;
			$line =~ s/a/A/g;
			$line =~ s/c/C/g;
			$line =~ s/t/T/g;
			$FastaHash{$FastaID} = $line;
			$FastaErrorCounter = 2;
			next;
		} elsif ($line =~ /^\+/ && $FastaErrorCounter == 2) {
			$FastaErrorCounter = 3;
			next;
		} elsif ($FastaErrorCounter == 3) {
			chomp $line;
			$QualityHash{$FastaID} = $line;
			$FastaErrorCounter = 0;
			next;
		} else {
			die "There is a problem with the fastq file. Check line order. $!\n";
		}
	}
	return (\%FastaHash, \%QualityHash);
}

sub TrimSeqs {
	my ($FastaHash, $QualityHash) = @_;
	while ( my ($ID, $NucSeq) = each %FastaHash) {
		# Get quality string
		my $qualityString = $QualityHash -> {$ID};
		# Convert to ASCII
		$qualityString=~s/(.)/ord($1)."-"/eg;
		$qualityString=~s/$RangeRegex\S+$//g;
		$qualityString=~s/[^-]//g;
		$QualLength=length($qualityString);
		$TrimmedSeq=substr($NucSeq, 0, $QualLength);
		# Return the resulting sequence as fasta
		print OUT "\>$ID\n";
		print OUT "$TrimmedSeq\n";
	}
}

my ($FastaSub, $FastqSub) = ReadInFastq(\*IN);
TrimSeqs($FastaSub, $FastqSub);

close(IN);
close(OUT);

my $end_run = time();
my $run_time = $end_run - $start_run;
print STDERR "Quality trimmed fastq in $run_time seconds.\n";

=head1 NAME

QualityTrim.pl

=head1 SYNOPSIS

Given a quality threshold value, this script will trim a set of fastq sequences
and remove and bases after the first occurance of a low quality nucleotide.

=head1 OPTIONS

CreateTableOfContents.pl 

	-f <input fastq>

	-o <output file>

	-c <numeric quality cutoff value>

=head1 ARGUMENTS

-h | --help	Print this helpful help menu.

-i | --input	Input fastq file to be trimmed

-o | --output	Output fasta file to which sequences will be written to

-c | --cutoff	Numeric value for the quality threshold to be used for trimming. Default is 33.

=cut
