#!/usr/bin/env bash
#
# vim: set fdm=marker :
# A lot of this is based on options.bash by Daniel Mills.
# @see https://github.com/e36freak/tools/blob/master/options.bash

# Preamble {{{

#set -o nounset

# Exit immediately on error
set -e

# Detect whether output is piped or not.
[[ -t 1 ]] && piped=0 || piped=1

# Defaults
quiet=0
verbose=0
interactive=0
auth_required=1
args=()
_proxyhost="webproxy"
_proxyport="9090"
_proxyusername=$USER
_proxypassword=""

# }}}
# Helpers {{{

# $_ME
# Set to basename
_ME=$(basename "${0}")

out() {
  ((quiet)) && return

  local message="$@"
  if ((piped)); then
    message=$(echo $message | sed '
      s/\\[0-9]\{3\}\[[0-9]\(;[0-9]\{2\}\)\?m//g;
      s/✖/Error:/g;
      s/✔/Success:/g;
    ')
  fi
  printf '%b\n' "$message";
}
die() { out "$@"; exit 1; } >&2
err() { out " \033[1;31m✖\033[0m  $@"; } >&2
success() { out " \033[1;32m✔\033[0m  $@"; }

# Verbose logging
log() { (($verbose)) && out "$@"; }

# Notify on function success
notify() { [[ $? == 0 ]] && success "$@" || err "$@"; }

# Escape a string
escape() { echo $@ | sed 's/\//\\\//g'; }


# }}}
# Script logic -- TOUCH THIS {{{

version="v0.1"

# Print usage
usage() {
  echo -n "$_ME [OPTION]...

  Sets the http_proxy and https_proxy environment variables for your system, as
  well as other proxy related settings.

 Options:
  --dry-run         Run the script but don't actually change anything.
  -h, --help        Display this help and exit
  -H, --hostname    Hostname for the proxy
  -P, --port        Port number for proxy to use
  -u, --username    Username for script
  -p, --password    Input user password, it's recommended to insert
                    this through the interactive option
      --no-auth     No authentication is required for proxy. The  default is to
                    always use authentication unless this flag is present.
  -i, --interactive Prompt for values
  -q, --quiet       Quiet (no output)
      --version     Output version information and exit
  -v, --verbose     Output more
"
}

# Set a trap for cleaning up in case of errors or when script exits.
rollback() {
  die
}

# Put your script here
main() {
    ${_proxy:-}
    log "Using hostname: $_proxyhost"
    log "Using port: $_proxyport"
    log "Using Username: $_proxyusername"
    if (($auth_required)); then
        if [ -z $_proxypassword ]; then
            die "Password is required! Try running $_ME -iy"
        fi
        _proxy=https://$_proxyusername:$_proxypassword@$_proxyhost:$_proxyport/
    else
        _proxy=https://$_proxyhost:$_proxyport/
    fi

    log "Setting proxy environment variables..."
    if ! ((dryrun)); then
        export http_proxy=$_proxy
        export https_proxy=$_proxy
        # export ftp_proxy=$_proxy
        out "http_proxy settings set for this shell"
    else
        out "http_proxy settings would be set for this shell"
    fi

    if ! ((dryrun)); then
        # TODO: this should be an optional setting at somepoint
        log "Updating /etc/apt/apt.conf"
        sudo sed -i -r 's|^(Acquire::https?::Proxy ")[^"]*(";)|\1'"$proxy"'\2|gm' /etc/apt/apt.conf
    else
        out "Would set apt.conf"
    fi
}

# }}}
# Boilerplate {{{

# Prompt the user to interactively enter desired variable values.
prompt_options() {

  read -p "Proxy Hostname [$_proxyhost]: " -e input
  : _proxyhost=${input:=$_proxyhost}
  read -p "Proxy Port [$_proxyport]: "  -e input
  : _proxyport=${input:=$_proxyport}

  if (($auth_required)); then
    read -p "Proxy username [$defaultproxyusername]: " -e input
    : _proxyusername=${input:=$_proxyusername}
    read_secret _proxypassword
  fi

}

# Iterate over options breaking -ab into -a -b when needed and --foo=bar into
# --foo bar
optstring=h
unset options
while (($#)); do
  case $1 in
    # If option is of type -ab
    -[!-]?*)
      # Loop over each character starting with the second
      for ((i=1; i < ${#1}; i++)); do
        c=${1:i:1}

        # Add current char to options
        options+=("-$c")

        # If option takes a required argument, and it's not the last char make
        # the rest of the string its argument
        if [[ $optstring = *"$c:"* && ${1:i+1} ]]; then
          options+=("${1:i+1}")
          break
        fi
      done
      ;;
    # If option is of type --foo=bar
    --?*=*) options+=("${1%%=*}" "${1#*=}") ;;
    # add --endopts for --
    --) options+=(--endopts) ;;
    # Otherwise, nothing special
    *) options+=("$1") ;;
  esac
  shift
done
set -- "${options[@]}"
unset options

# Set our rollback function for unexpected exits.
trap rollback INT TERM EXIT

# A non-destructive exit for when the script exits naturally.
safe_exit() {
  trap - INT TERM EXIT
  exit
}

# }}}
# Main loop {{{

# Print help if no arguments were passed.
[[ $# -eq 0 ]] && set -- "--help"

# Read the options and set stuff
while [[ $1 = -?* ]]; do
  case $1 in
    --dry-run) dryrun=1 ;;
    --endopts) shift; break ;;
    -h|--help) usage >&2; safe_exit ;;
    -H|--hostname) shift;_proxyhostname=$1 ;;
    -i|--interactive) interactive=1 ;;
    -P|--port) shift;_proxyport=$1 ;;
    --no-auth) _auth_required=0 ;;
    -p|--password) shift; _proxypassword=$1 ;;
    -u|--username) shift;_proxyusername=$1 ;;
    -v|--verbose) verbose=1 ;;
    --version) out "$_ME $version"; safe_exit ;;
    -q|--quiet) quiet=1 ;;
    *) die "invalid option: $1" ;;
  esac
  shift
done

# Store the remaining part as arguments.
args+=("$@")

# }}}
# Run it {{{

# Uncomment this line if the script requires root privileges.
# [[ $UID -ne 0 ]] && die "You need to be root to run this script"

if ((interactive)); then
  prompt_options
fi

# You should delegate your logic from the `main` function
main

# This has to be run last not to rollback changes we've made.
safe_exit

# }}}
