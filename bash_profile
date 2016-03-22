#!/bin/bash

# Init settings executed for interactive login shells only

# Init settings for all interactive shells (Common for interactive login and non-login shells.)
if [[ -f ~/.bashrc ]]; then
    source ~/.bashrc
fi
