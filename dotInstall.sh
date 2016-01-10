#!/bin/bash
###########
# dotInstall.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
###########

###### Helper func
function timestamp(){
     date +"%Y%m%d.%H%M%S"
}

msg() {
    printf '%b\n' "$1" >&2
}

success() {
    if [ "$ret" -eq '0' ]; then
        msg "\33[32m[✔]\33[0m ${1}${2}"
    fi
}

error() {
    msg "\33[31m[✘]\33[0m ${1}${2}"
    exit 1
}

debug() {
    if [ "$debug_mode" -eq '1' ] && [ "$ret" -gt '1' ]; then
        msg "An error occurred in function \"${FUNCNAME[$i+1]}\" on line ${BASH_LINENO[$i+1]}, we're sorry for that."
    fi
}

program_exists() {
    local ret='0'
    command -v $1 >/dev/null 2>&1 || { local ret='1'; }

    # fail on non-zero return value
    if [ "$ret" -ne 0 ]; then
        return 1
    fi

    return 0
}

program_must_exist() {
    program_exists $1

    # throw error on non-zero return value
    if [ "$?" -ne 0 ]; then
        error "You must have '$1' installed to continue."
    fi
}

variable_set() {
    if [ -z "$1" ]; then
        error "You must have your HOME environmental variable set to continue."
    fi
}

lnif() {
    if [ -e "$1" ]; then
        ln -sf "$1" "$2"
    fi
    ret="$?"
    debug
}


###### Variables

dir=~/dotfiles                         # dotfiles directory
olddir=~/dotfiles_old/$(timestamp)     # old dotfiles backup directory
# list of files/folders to symlink in homedir
files="vimrc gitconfig gitignore vim"

###### 



# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~/"
mkdir -p $olddir

echo "done..."

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir

echo "done..."

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
for file in $files; do
    echo "Moving $file from ~/ to $olddir"
    mv ~/.$file $olddir
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done
echo ""

