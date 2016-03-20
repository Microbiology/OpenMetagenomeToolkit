[![Twitter Follow](https://img.shields.io/twitter/follow/iprophage.svg?style=social)](https://twitter.com/iprophage)

# The Open Metagenome Toolkit
A collaborative and open source toolkit to facilitate metagenomic analysis. This toolkit focuses on virus metagenomics.

**Maintained** by [Geoffrey Hannigan](http://microbiology.github.io)

###Emphasis on Mobility
This toolkit is focused on mobility. Dependencies are minimal so just [download the most recent release](https://github.com/Microbiology/Microbiome_sequence_analysis_toolkit/releases) and you should be good to go.

###Getting Involved
The goal is for this to be a collaborative effort that makes metagenomic analysis easier for everyone. Get involved as a **contributor** to get your **name** added to this repository homepage.

Additionally, if this package is ever published in a peer reviewed journal, I am happy to **share authorship** with the contributors.

Contribute by adding your own scripts, or by adding functionality to the existing scripts.

Ideas for new scripts or functionalities? Create an issue.

#The Virus Metagenomic SOP (Work In Progress)

###1. Trim Sequence Adapters
Illumina sequencing platforms often have adapters in their resulting sequences. We often think of these as the adapters near the beginning of the read, and these are often removed by the Illumina software. Sometimes the adapters at the end are also included when the read is short enough to allow it to read through the end of the DNA fragment. It is important to remove all of these adapters using **cutadapt**.

###2. Quality Trimming
Nucleotides are called with varying confidence. The quality of each nucleotide of each sequence is included in the **fastq** file. We want to remove all nucleotides whose quality score does not meet our defined threshold.

###3. Decontamination
We as scientists are often legally required to remove any sequence information that could be used to identify the sample donor, although this does depend on the project-specific IRB and other regulations. This means that human DNA sequences must be removed from the dataset. These can be removed using the program **deconseq**, although other programs can also be used.

###4. Negative Control Removal
As with any experiment, it is important to process negative control samples so that we can define the background noise. If any sequences are detected in the negative control sample, those sequences should be removed from the experimental sample because their biological relevance is in question. We can use the scripts in this toolkit to remove any shared sequences between the negative control and experimental samples.
