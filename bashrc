#!/usr/bin/env bash

#{{{1 Set up env
if [ ! -z "$RCRELOAD" ]; then
    unset \
        DIRBashrc \
        ALIASES \
        BASHCOLORS \
        PROMPTRC \
        RCSHELL \
        RCRELOAD
fi
#}}}
#{{{1 Set up directories
[ -z "$DIRBashrc" ]     && DIRBashrc="$HOME/.bash/rc"
[ -z "$ALIASES" ]       && ALIASES="$DIRBashrc/aliases"
[ -z "$BASHCOLORS" ]    && BASHCOLORS="$DIRBashrc/colors"
[ -z "$PROMPTRC" ]      && PROMPTRC="$DIRBashrc/prompt"
[ -z "$RCSHELL" ]       && RCSHELL="$DIRBashrc/shell_env"
#}}}
#{{{1 source setup scripts
[ -e "$RCSHELL" ]       && source "$RCSHELL"
[ -e "$BASHCOLORS" ]    && source "$BASHCOLORS"
[ -e "$PROMPTRC" ]      && source "$PROMPTRC"
[ -e "$ALIASES" ]       && source "$ALIASES"


source_files_in() {
    local dir="$1"

    if [[ -d "$dir" && -r "$dir" && -x "$dir"  ]]; then
        for file in "$dir"/*; do
           [[ -f "$file" && -r "$file"  ]] && . "$file"
       done
   fi

}

#{{{1 Source RC files
DIRBashrc="$HOME/.bash/rc/"

# need to figure out how to make sure files are sourced in order
#source_files_in $DIRBashrc
#}}}

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/b88mjr/.sdkman"
[[ -s "/home/b88mjr/.sdkman/bin/sdkman-init.sh" ]] && source "/home/b88mjr/.sdkman/bin/sdkman-init.sh"
