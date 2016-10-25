## UPDATE ##
#to add files for committing into my repo

git add . #inside my repo folder

#mind to use the '--all' option to add changes for ALL FILES,  in this fashon

git add --all .

##to commit changes and add commit messages

git commit - m 'changelog' #changelog == whatever you changed

##to send changes to my git repository

git push -u origin --all #pushes the changes to the "origin" branch of the repo for all files

####################

##CONFIGURATION##
##to initialize repository inside your local direcotry

git init

##to add my repo to a source directory on your local machine 
git remote add origin https://github.com/wariobrega/scrapcode.git

##to clone repository inside a directory in youyr local machine 

git clone https://github.com/wariobrega/scrapcode.git

#to add a new remote repository  

git remote add REPONAME REPOURL #after haviong created it on github

#adding username
git config --global user.name wariobrega

#adding user email
git config --global user.email wariobrega@gmail.com

#maually edit git config
git config --global --edit

##adding a default editor for git
git config --global core.editor subl #this is sublimetext 3
###########################

##OTHER TOOLS ##

#to update git index

git update-index --assume-unchanged

# to remove file that does not need to be in  git anymore

git rm -f FILENAME #(inside repositiroy)



