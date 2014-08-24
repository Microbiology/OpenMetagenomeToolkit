Removing Block Fasta Format
===========================

Sometimes sequence fasta files are reported in "block fasta" format, meaning the sequence contains newlines. An example is as follows:

	$test_block.fasta

	>Sequence_1
	TATGCTGAGTCAGTCTGCAGTCAGTACGTCAGTCAGTCAT
	TGCAGTCATTGACGGTCAGACGACTGCAGTCATCAGTACG
	TCAGTACCTAAC
	>Sequence_2
	CAGCAGTCAGTCATCATGACGTCAGTCAGTCAGTCAGTCA
	GTCAGTCAGTCAGACGCA
	>Sequence_3
	GACGTCAGTACTGCAGTCAGACGTCATCGTCAGTCAGTCA
	GTCATATACTCAGCGTCTATGACCGCAGTCAGTC

This makes the sequences easier for humans to read, but can complicate downstream analyses.  The simple script 'remove_block_fasta_format.pl' will remove the newlines to generate a fasta sequence file like the following:

	$test_no_block.fasta

	>Sequence_1
	TATGCTGAGTCAGTCTGCAGTCAGTACGTCAGTCAGTCATTGCAGTCATTGACGGTCAGACGACTGCAGTCATCAGTACGTCAGTACCTAAC
	>Sequence_2
	CAGCAGTCAGTCATCATGACGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGACGCA
	>Sequence_3
	GACGTCAGTACTGCAGTCAGACGTCATCGTCAGTCAGTCAGTCATATACTCAGCGTCTATGACCGCAGTCAGTC

To run this script, simply write the input and output file names after the name of the script you are calling in perl.

	$perl remove_block_fasta_format.pl test_block.fasta test_no_block.fasta

This script will work with both DNA/RNA sequences, as well as amino acid protein sequences.

