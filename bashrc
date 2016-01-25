#!/usr/bin/env bash

#{{{1 Set up directories
[ -z "$DIRBashrc" ]     && DIRBashrc="~/.bash/rc"
[ -z "$BASHCOLORS" ]    && BASHCOLORS="$DIRBashrc/colors"
[ -z "$PROMPTRC" ]      && PROMPTRC="$DIRBashrc/prompt"
echo "colors: $BASHCOLORS"
#{{{1 source setup scripts
[ -e "$BASHCOLORS" ]    && source "$BASHCOLORS"
[ -e "$PROMPTRC" ]      && source "$PROMPTRC"
[ -e "$ALIASES" ]       && source "$ALIASES"
