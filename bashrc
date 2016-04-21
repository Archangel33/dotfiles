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
[ -z "$RCSHELL" ]       && RCSHELL="$DIRBashrc/shell"
#}}}
#{{{1 source setup scripts
[ -e "$RCSHELL" ]       && source "$RCSHELL"
[ -e "$BASHCOLORS" ]    && source "$BASHCOLORS"
[ -e "$PROMPTRC" ]      && source "$PROMPTRC"
[ -e "$ALIASES" ]       && source "$ALIASES"
#}}}
