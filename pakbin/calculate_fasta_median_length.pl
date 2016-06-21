# !/usr/local/bin/perl -w
# calculate_fasta_median_length.pl
# Geoffrey Hannigan
# Elizabeth Grice Lab
# University of Pennsylvania

# Set use
use strict;
use warnings;

# Set files to scalar variables
my $usage = "Usage: perl $0 <INFILE>";
my $infile = shift or die $usage;
open(my $IN, "<", "$infile") || die "Unable to open $infile: $!";

# Set variable for list of length values
my @lengths = ();
my $line_length = 0;
my $result = 0;

# Assign lengths of each sequence to the array
while (my $line = <$IN>) {
	# Skip the sequence identifier lines
	if ($line =~ /\>/) {
		next;
	} else {
		# Add  line lengths to array
		chomp $line;
		my $line_length = length $line;
		push @lengths, $line_length;
	}
}

# Sort the length array
my @sorted_lengths = sort {$a <=> $b} @lengths;
# Assign array length to a variable
my $array_length = @sorted_lengths;

# Get the median of the array, depending on whether the link is even or odd
if ($array_length%2) {
	# Odd
	my $result = $sorted_lengths[($array_length/2)];
	printf $result."\t".$infile."\n";
} else {
	# Even
	my $one = $sorted_lengths[($array_length/2)-1];
	my $two = $sorted_lengths[($array_length/2)];
	my $result = ($one + $two) / 2;
	printf $result."\t".$infile."\n";
}

#Close out files
close($IN);
