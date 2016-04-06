#!/usr/bin/env bash
# vim: foldlevel=1 spell
# dotInstall.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/.dotfiles
#########
set -e           # exit on command errors make sure to handle error codes appropriatly
set -o pipefail  # catched fial exit codes on piped commands
# set -x         # turn on bash debugging mode

###### COLORS {{{1
CNORM="\33[0m"
CRED="\33[31m"
CGREEN="\33[32m"
MCHECK="✔"
MCROSS="✘"

###### VARS {{{1
[ "$VERBOSE" ] || VERBOSE=
[ "$DEBUG" ]   || DEBUG=

###### Helper Funcs {{{1

timestamp(){ date +"%Y%m%d.%H%M%S"; }
out() { printf "$(timestamp): $*\n"; }
err() { out "$CRED[$MCROSS]$CNORM$*" 1>&2; }
vrb() { [ ! "$VERBOSE" ] || out "$@"; }
dbg() { [ ! "$DEBUG" ] || err "$@"; }
die() { err "EXIT: $1" && [ "$2" ] && [ "$2" -ge 0 ] && exit "$2" || exit 1; }
msg() { out "$*"; }
status_msg() {
    local outcmd="$1"; shift
    if [[ "$ret" -eq '0' ]]; then
        $outcmd "$CGREEN[$MCHECK]$CNORM Success: $@";
    else
        err "$CRED[$MCROSS]$CNORM Failed: $*";
    fi
    return 0
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
    local target=${1}
    local link=${2}

    if [ -e "$target" ]; then
        if windows; then
            # tell windows to make a dir/file sym link
	    target=$(winpath "$target")
	    link=$(winpath "$link")
	    echo "target: ${target}"
	    echo "link: ${link}"
            if [[ -d "$target" ]]; then # dir
                cmd <<< "mklink /D \"${link}\" \"${target}\"" > /dev/null
            else # file
                cmd <<< "mklink \"${link}\" \"${target}\"" > /dev/null
            fi
        else
            ln -sfn "$target" "$link"
        fi
    fi
    ret="$?"
}
dir_must_exist() {
    if [ ! -d $1 ]; then
        mkdir -p $1
    fi
    ret="$?"
}
windows() {
    [[ -n "$WINDIR" ]]
}
winpath() {
    echo "$1" \
    | sed \
      -e 's|^/\(.\)/|\1:\\|g' \
      -e 's|/|\\|g'
}

unixpath() {
    echo "$1" \
    | sed -r \
      -e 's/\\/\//g' \
      -e 's/^([^:]+):/\/\1/'
}

###### Variables {{{1

[ -z "$DOTFILES_name" ]     && DOTFILES_name="dotfiles"
[ -z "$DOTFILES_path" ]     && DOTFILES_path="$HOME/dotfiles"                                # dotfiles directory
[ -z "$DOTFILES_backup" ]   && DOTFILES_backup="$HOME/.dotfiles_old/$(timestamp)"              # old dotfiles backup directory
[ -z "$DOTFILES_URI" ]      && DOTFILES_URI='https://github.com/Archangel33/dotfiles.git'   # repo URI of
[ -z "$DOTFILES_branch" ]   && DOTFILES_branch='master'                                        # branch to pull your dotfiles from
DOTFILES="vimrc gitconfig gitignore vim bash bashrc"                                                        # list of files/folders to symlink in homedir

[ -z "$VUNDLE_name" ]   && VUNDLE_name="vundle"                                            # name of vundle
[ -z "$VUNDLE_path" ]   && VUNDLE_path="$HOME/.vim/bundle/vundle"                          # Path to bundles dir for Vundle
[ -z "$VUNDLE_URI" ]    && VUNDLE_URI="https://github.com/gmarik/vundle.git"              # URI for Vundle plugin for vim
[ -z "$VUNDLE_branch" ] && VUNDLE_branch="master"                                            # branch from pull vundle frome
[ -z "$VUNDLE_default_bundle_path" ] && VUNDLE_default_bundle_path="vim/rc/bundles.vim"

[ -z "$BASHRC_path" ]   && BASHRC_path="$HOME/.bashrc"

###### Install functions {{{1
do_backup() {
    msg "Backing up current dotfiles:"
    vrb $1
    for file in $1; do
        if [[ -e ~/.$file ]]; then
            [[ ! -L ~/.$file ]] && mv -v ~/.$file $2
            ret="$?"
            status_msg vrb "Moving ~/.$file to $2"
        else
            err "$file does not exist"
        fi
    done
    if [[ ! $ret = "0" ]]; then
        err "Backup"
    fi
    return $ret
}

find_symlinks(){
    $(find -H "$DOTFILES_ROOT" -name '*.symlink')
}

create_symlinks(){
    debug "Aggregating Symlinks"
    local symlinksToBe=$1
    local dotsymlinkNodes=find_symlinks
    msg "Creating Symlinks"
    for file in symlinksToBe; do
        action="~/.$file to $2/$file"
        vrb "Symlinking: ln $2/$file $(echo ~/.$file)"
        lnif $2/$file ~/.$file
        ret="$?"
        status_msg vrb "linking $action"
    done
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
        status_msg out "Cloning $repo_name."
    else
        cd "$repo_path" && git pull origin "$repo_branch"
        ret="$?"
        status_msg out "Updating $repo_name"
    fi
}

setup_vundle() {
    msg "Attempting to update Vim plugins using Vundle"
    local system_shell="$SHELL"
    export SHELL='/bin/sh'

    vim \
        -u "$1/$2" \
        "+set nomore" \
        "+VundleInstall!" \
        "+VundleClean" \
        "+qall"

    export SHELL="$system_shell"

    status_msg out "updating/installing plugins using Vundle"
}

setup_bash(){
    if [[ -e $1 ]]; then
    	msg "Sourcing $1"
    	source $1
    fi
}

################################ MAIN(){{{1
variable_set "$HOME"
program_must_exist "git"
program_must_exist "vim"
program_must_exist "sed"
dir_must_exist $DOTFILES_backup
dir_must_exist $DOTFILES_path

# Core setup {{{2
# backup existing dotfiles
do_backup       "$DOTFILES" \
                "$DOTFILES_backup"

# update to latest dotfiles
sync_repo       "$DOTFILES_path" \
                "$DOTFILES_URI" \
                "$DOTFILES_branch" \
                "$DOTFILES_name"

# setup symlinks
create_symlinks "$DOTFILES" \
                "$DOTFILES_path"

# Any application specific setup {{{2
# setup_Shell {{{3
setup_bash      "$BASHRC_path"

# Vundle {{{3
sync_repo       "$VUNDLE_path" \
                "$VUNDLE_URI" \
                "$VUNDLE_branch" \
                "$VUNDLE_name"

setup_vundle    "$DOTFILES_path" \
                "$VUNDLE_default_bundle_path"

