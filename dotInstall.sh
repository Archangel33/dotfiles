#!/bin/bash
# dotInstall.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/.dotfiles
###########
set -e           # exit on command errors make sure to handle error codes appropriatly
set -o pipefail  # catched fial exit codes on piped commands
# set -x         # turn on bash debugging mode

###### COLORS
CNORM="\33[0m"
CRED="\33[31m"
CGREEN="\33[32m"


###### VARS
[ "$VERBOSE" ] || VERBOSE=
[ "$DEBUG" ]   || DEBUG=

###### Helper func

function timestamp(){ date +"%Y%m%d.%H%M%S" }

out() { printf "$(timestamp): $*"; }
err() { out "$CRED[✘]$$CNORM$*" 1>&2; }
vrb() { [ ! "$VERBOSE" ] || out "$@"; }
dbg() { [ ! "$DEBUG" ] || err "$@"; }
die() { err "EXIT: $1" && [ "$2" ] && [ "$2" -ge 0 ] && exit "$2" || exit 1; } 

msg() {  }

success() {
    if [ "$ret" -eq '0' ]; then
        msg "$CGREEN[✔]$CNORM ${1}${2}"
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
}


###### Variables

dir=~/dotfiles                         # dotfiles directory
olddir=~/.dotfiles_old/$(timestamp)     # old dotfiles backup directory
# list of files/folders to symlink in homedir
files="vimrc gitconfig gitignore vim"

###### 

opts("$@")


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

do_backup() {
    out

}

sync_repo() {
    local repo_path="$1"
    local repo_uri="$2"
    local repo_branch="$3"
    local repo_name="$4"

    msg "Trying to update $repo_name"

    if [ ! -e "$repo_path" ]; then
        mkdir -p "$repo_path"
        git clone -b "$repo_branch" "$repo_uri" "$repo_path"
        ret="$?"
        success "Successfully cloned $repo_name."
    else
        cd "$repo_path" && git pull origin "$repo_branch"
        ret="$?"
        success "Successfully updated $repo_name"
    fi
}

################################ MAIN()
variable_set "$HOME"

do_backup        "$HOME"/.vim \

sync_repo        "" \

create_symlinks  "" \

setup_vundle     "" \


