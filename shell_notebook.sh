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


#unpack a tar file 

tar -xvf file.tar
