#transform_for_lefse.py
#Geoffrey Hannigan
#University of Pennsylvania
#Laboratory of Elizabeth Grice
#Created: 2014-01-17
#NOTE: This is a script for formatting Qiime alpha diversity files and mapping files for use in lefse.

import os, sys, argparse

#I want this script to be easily usable like Qiime scripts so I am going to define arguments that can be entered from the cmd line

parser = argparse.ArgumentParser(description='Use this script for formatting relative abundance files, taken directly from Qiime and used with mapping files, for Lefse analysis.  Ultimately this will merge your relative abundance table to your mapping file, replace every case of ; with |, and transpose the file so that it works in Lefse.  WARNING that this script uses tmp folders like tmp1.txt so please make sure that your local directory does not include any files with this type of name.  Please also NOTE that you will likely have many columns of meta-data in your mapping file, and Lefse does not work well with these.  At this point you are going to have to delete the rows of meta-data that you do not want to use, so that it can be entered into Lefse.')

parser.add_argument('-i', '--input', metavar='file_name', type=argparse.FileType('r'), help='input relative abundance table from Qiime')
parser.add_argument('-m', '--mapfile', metavar='file_name', type=argparse.FileType('r'), help='mapping file')
parser.add_argument('-o', '--output', metavar='file_name', type=argparse.FileType('w'), help='output relative abundance table for Lefse')

args = parser.parse_args()

#Search for semicolon and replace with pipe, also replace empty spaces with underscores
f2 = open('./tmp1.txt', 'w')
for line in args.input:
	space_replace = line.replace(' ', '_')
	f2.write(space_replace.replace(';', '|'))

f2.close()

#Transpose the resulting file from above
f1 = open('./tmp2.txt', 'w')
with open('./tmp1.txt') as f:
	lis=[x.split() for x in f]

for x in zip(*lis):
	for y in x:
		f1.write(y+'\t')
	f1.write('\n')

f1.close()

#Merge the mapping file information to the transposed relative abundance table based on having the same sample IDs
# This gives me a dictionary with all of the ID numbers correlating to the remainder of the row values.  See here for the reference I used to get started: http://stackoverflow.com/questions/15663323/matching-different-columns-and-combine-them-using-python
f_result = open('./tmp3.txt', 'w')
with open('./tmp2.txt', 'rb') as f1:
	f1_data = dict(line.split('\t',1) for line in f1)

for line in args.mapfile:
	row=line.strip().split('\t')
	key = row[0]
	map = f1_data[key]
	map2 = map.split('\t')
	map3 = row + map2
	f_result.write('\t'.join(map3))

f_result.close()

#Transpose the file back again once the mapping file has been merged to the relative abundance table
with open('./tmp3.txt') as f:
	lis=[x.split() for x in f]

for x in zip(*lis):
	for y in x:
		args.output.write(y+'\t')
	args.output.write('\n')

#Have the operating system remove the tmp.txt files that were created while the script was running above.
os.remove('./tmp1.txt')
os.remove('./tmp2.txt')
os.remove('./tmp3.txt')
