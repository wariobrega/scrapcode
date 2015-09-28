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
#just remember that exec expects an ";" charachyter at the end of the expresion to execute or will raise an error
#the "+"character in the exec means "execute this command multiple times, stil have to figure it out precisely how it works though
find -type f -name *REGEX* -exec ls -lhrt {} +;



