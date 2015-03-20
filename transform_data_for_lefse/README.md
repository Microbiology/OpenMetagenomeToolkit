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

Other additional considerations for using the script include:
- Avoid empty fields or cells in your data tables as this will throw off the script.
- The mapping file should only have information for the samples included in the relative abundance table. Having more samples in the mapping file or relative abundance table will throw off the script.
- For now, the first row of the first column needs to be the same name. Please change them both to something like "SampleID". I will get around to automating this, but for now just maually change it real quick.

If you have questions or comments, feel free to email me at ghanni@upenn.edu
