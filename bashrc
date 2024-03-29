#!/usr/bin/env bash
#
# Currently these files have an order to them, sort of. Need to look into what
# order that is exactly and if there is a better way of "autoloading" them.

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
[ -z "$DOCKER" ]        && DOCKER="$DIRBashrc/docker"
#}}}
#{{{1 source setup scripts
[ -e "$DIRBashrc/tmux" ] && source "$DIRBashrc/tmux" # don't waste time setting up stuff unless were in a tmux session
[ -e "$RCSHELL" ]       && source "$RCSHELL"
[ -e "$BASHCOLORS" ]    && source "$BASHCOLORS"
[ -e "$PROMPTRC" ]      && source "$PROMPTRC"
[ -e "$ALIASES" ]       && source "$ALIASES"
[ -e "$DOCKER" ]       && source "$DOCKER"
#}}}

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
# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

export GOPATH=/d/go


export PATH=$PATH:/home/b88mjr/bin

source '/home/b88mjr/lib/azure-cli/az.completion'

complete -C /usr/bin/terraform terraform
