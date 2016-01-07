#!/bin/bash
###########
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
###########

###### Variables

dir=~/dotfiles                         # dotfiles directory
olddir=~/dotfiles_old . timestamp()    # old dotfiles backup directory
# list of files/folders to symlink in homedir
files="vimrc gitconfig gitignore"

###### 

timestamp(){
     date +"%Y%m%d.%H%M%S"
}

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~/"
if ! mkdir -p $olddir 2>/dev/null; then
    echo "Failed to create $olddir" 
    exit
fi
echo "done..."

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
if ! $PWD == $dir; then
    echo "Failed to change directory to $dir"
    exit
fi
echo "done..."

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
for file in $files; do
    echo "Moving $file from ~/ to $olddir"
    mv ~/.$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done
echo ""

