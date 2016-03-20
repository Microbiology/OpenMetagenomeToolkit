#!/usr/bin/perl
# TranslateFasta.pl
# Geoffrey Hannigan
# Pat Schloss Lab
# University of Michigan

# Set use
use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
# And because I like timing myself
my $start_run = time();

# Set variables
my %prot;
my $output;
my $fasta;
my $opt_help;
my $FastaErrorCounter = 0;
my $length;
my $divisible;
my $CodonSeq;
my $AminoAcid;

GetOptions(
	'h|help' => \$opt_help,
	'f|fasta=s' => \$fasta,
	'o|output=s' => \$output
);

pod2usage(-verbose => 1) && exit if defined $opt_help;

open(FASTA, "<$fasta") || die "Unable to read $fasta: $!";
open(OUT, ">$output") || die "Unable to write to $output: $!";

sub SetCodonHashInMemory {
	print STDERR "PROGRESS: Loading in amino acid codon hash.\n";
	my %prot = (
		'TCA'=>'S','TCC'=>'S','TCG'=>'S','TCT'=>'S',
		'TTC'=>'F','TTT'=>'F',
		'TTA'=>'L','TTG'=>'L',
		'TAC'=>'Y','TAT'=>'Y',
		'TAA'=>'_','TAG'=>'_','TGA'=>'_',
		'TGC'=>'C','TGT'=>'C',
		'TGG'=>'W',
		'CTA'=>'L','CTC'=>'L','CTG'=>'L','CTT'=>'L',
		'CCA'=>'P','CCC'=>'P','CCG'=>'P','CCT'=>'P',
		'CAC'=>'H','CAT'=>'H',
		'CAA'=>'Q','CAG'=>'Q',
		'CGA'=>'R','CGC'=>'R','CGG'=>'R','CGT'=>'R',
		'ATA'=>'I','ATC'=>'I','ATT'=>'I',
		'ATG'=>'M',
		'ACA'=>'T','ACC'=>'T','ACG'=>'T','ACT'=>'T',
		'AAC'=>'N','AAT'=>'N',
		'AAA'=>'K','AAG'=>'K',
		'AGC'=>'S','AGT'=>'S',
		'AGA'=>'R','AGG'=>'R',
		'GTA'=>'V','GTC'=>'V','GTG'=>'V','GTT'=>'V',
		'GCA'=>'A','GCC'=>'A','GCG'=>'A','GCT'=>'A',
		'GAC'=>'D','GAT'=>'D',
		'GAA'=>'E','GAG'=>'E',
		'GGA'=>'G','GGC'=>'G','GGG'=>'G','GGT'=>'G'
	);
	return %prot;
}

my %CodonHash = SetCodonHashInMemory();

print STDERR "PROGRESS: Translating Fasta..\n";

foreach my $line (<FASTA>) {
	if ($line =~ /\>/ && $FastaErrorCounter == 0) {
		print OUT $line;
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
		# Iterate through the codons using a sliding window
		$length = length($line);
		$divisible = $length % 3;
		# Check it is divisible by three
		die "Killed because gene is not divisible by three: $!" unless ($divisible == 0);
		for (my $NucIter = 0; $NucIter < $length; $NucIter += 3) {
			$CodonSeq = substr($line, $NucIter, 3);
			$AminoAcid = $CodonHash{$CodonSeq};
			print OUT "$AminoAcid";
		}
		print OUT "\n";
		$FastaErrorCounter = 0;
	}
}

close(FASTA);
close(OUT);

# How long did it take
my $end_run = time();
my $run_time = $end_run - $start_run;
print STDERR "Translated fasta in $run_time seconds.\n";

=head1 NAME

TranslateFasta.pl

=head1 SYNOPSIS

Given a fasta of nucleotides, this script will translate the sequence
into an amino acid sequence. Fastas with multiple sequences are not
only accepted, but encouraged.

=head1 OPTIONS

CreateTableOfContents.pl 
	-f <input fasta>
	-o <output fasta>

=head1 ARGUMENTS

-h | --help	Print this helpful help menu.

-f | --fasta	Input fasta file to be translated

-o | --output	Output fasta file to which sequences will be written to

=cut
