#!/usr/local/bin/perl -w
# LengthFilterSeqs.pl
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

# Set Variables
## Options
my $opt_help;
my $input;
my $output;
my $minimum = 0;
my $maximum = 250;
## Files
my $IN;
my $OUT;
## Misc
my $flag = 0;
my $LineLength;
my $lineName;

# Set options
GetOptions(
	'h|help' => \$opt_help,
	'i|input=s' => \$input,
	'o|output=s' => \$output,
	'm|minimum=n' => \$minimum,
	'n|maximum=n' => \$maximum
);

pod2usage(-verbose => 1) && exit if defined $opt_help;

open($IN, "<", "$input") || die "Unable to read $input: $!";
open($OUT, ">", "$output") || die "Unable to write to $output: $!";

# Now run the filter
while (my $line = <$IN>) {
	chomp $line;
	if ($line =~ /^\>/ && $flag==0) {
		$lineName = $line;
		$flag = 1;
		next;
	} elsif ($line !~ /^\>/ && $flag==1) {
		$LineLength = length $line;
		if ($LineLength <= $maximum && $LineLength >= $minimum) {
			print $OUT "$lineName\n$line\n";
		}
		$flag = 0;
		$lineName = '';
	} else {
		die "Error in fasta format: $!";
	}
}

close($IN);
close($OUT);

my $end_run = time();
my $run_time = $end_run - $start_run;
print STDERR "Quality trimmed fastq in $run_time seconds.\n";
