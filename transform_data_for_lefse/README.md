Qiime to lefse format
=====================

ABOUT
Quickly format Qiime output files so that they can be used in the online program Lefse
Lefse is an online program from the Huttenhower Lab and can be found at <http://huttenhower.sph.harvard.edu/galaxy/>
Lefse is an online program that can take relative abundance data (we use microbial relative abndance as calculated in the program Qiime) and search for biomarkers associated with certain conditions.


USAGE
Use the script transform_data_for_lefse.py to prepare Qiime relative abundance tables and your mapping file for input into Lefse

The two input files required are a standard Qiime relative abundance output file (with the bacterial taxa in the first column and the sample identifications in the first row) and a standard Qiime mapping file (the identifiers in the mapping file should match those in the relative abundance file).  Please note that the headers for the identification columns in the mapping and alpha diversity files should be the same.

Also note that this script requires you to remove the mapping file columns (the columns of meta-data) that you will not use because Lefse requires you to only include the meta-data you will be using.

To use the HELP menu of the script use the -h flag:
python transform_data_for_lefse.py -h

DEVELOPER NOTES
I am new to github and would love feedback or for you to work with me on this package.

If you have questions or comments, feel free to email me at ghanni@upenn.edu
