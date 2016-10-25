##extract the first n lines from a compressed txt file

gzip -cd compressed.gz | head -n4000 > test.txt

##find all files recursively in a directory and count name
#specifically:
#- type f means LOOK FOR FILES ONLY
# -name *RTEGEX* means LOOK FOR ELEMENTS MATCHING THIS REGEX ONLY

find -type f -name *REGEX* | wc -l

#alternatively, we can associate a list operation, like showing the size of each file

ls -l $(find -type f  -name *REGEX*)

#alternatively, we can exec the list operation INSIDE the find command and without assigning him to a new variable
#just remember that exec expects an ";" charachter at the end of the expresion to execute or will raise an error
#the "+"character in the exec means "execute this command multiple times, stil have to figure it out precisely how it works though
#the {} parenthesis means "execute the command where the find directory was launched from

find -type f -name *REGEX* -exec ls -lhrt {} +;

#alternatively, now that we're pretty good at it, let's use find inside a specific directory to takje all the PATHS for a specific regex and then count the output of the list operation!

find ~/PATH -type f -name *REGEX* -exec ls -lhrt {} + | wc -l

#other useful find trick: how to remove all files in a directory but the one matching a regex?
#assuming we want to delete ALL but a .fastq file:
find . \! -name '*.fastq' -delete

#how to use rsync: -avPu (check the man for more info on this

rsync -avPu PATH/TO/SOURCE PATH/TO/DEST

## find a specific file type and cat all files found into a single file in append mode
# (in this case find all flagstat file and output them with the name of the directory they were into)

for file in $(find tophat_alignments_* -type f -name *flagstat); 
do 
	a=$(dirname $file); 
	echo $a$ >> flagstatsummary.log; 
	cat $file >> flagstatsummary.log; 
	echo $'\n' >> flagstatsummary.log; 
done


##unpack a tar file 

tar -xvf file.tar

## parallel: launch multiple cmd line tool on the same shell at the same time! (have to be installed)
#parallel takes in input the output of any command that list files (so find, ls, or a file containing files), and performs multiple operations on them simoultaneously
# let's for example find a series of BAM files inside a list of dorectories and parallelize the sortiung using SAMTOOLS
find /path/to/yourdir -type f -name *.bam | parallel -j 7 samtools sort {} {.}_sorted &
#meanings:
#-j 7 : parallelize 7 processes at a time
#{} filename of each file listed
#{.} filename without extension (see man parallel for more file options

#let's use a temporary directory specified by the user to store temporary data for a series of sam files in a direcotry that needs to be converted
ls *.sam | parallel -j 7 --tmpdir /path/to/tmp samtools view -bS {} '>' {.}.bam &
#in this case, we redirect the stdout using the '>' parameter! (don't ask about the single quotes though'

#find a series of files with same name inside direstores, read tham and then ioutpout them in a file using directory name of the stored file as header
for file in $(find -type f -name *FILE.EXT ); \
do a=$(dirname $file); \
b=$(basename $a); \
echo $b; \
cat $file; \
echo -e "\n"; \
done > output_summary.txt
