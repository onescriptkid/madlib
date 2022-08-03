#!/usr/bin/env bash
###################################################################
# Script Name       : example.sh
# Description       : <description>
# Author       	    : <anonymous>                                                
# Email             : <anonymous@gmail.com> 
###################################################################

# Setup script
setup() {
  :
  # Unofficial bash strictmode - http://redsymbol.net/articles/unofficial-bash-strict-mode/
  set -euo pipefail
  IFS=$'\n\t'
  shopt -s globstar

  # Directory of the executed script
  SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

  # Delightful git commands
  GIT_REPO=$(git rev-parse --show-toplevel)
  GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  GIT_HASH=$(git rev-parse HEAD)
  GIT_SHORT_HASH=$(git rev-parse --short HEAD)

  # Grab the git version
  if ! git describe --tags --abbrev=0 --match "v[0-9]*" > /dev/null 2>&1; then
    GIT_VERSION=$(git describe --tags --abbrev=0 --match "v[0-9]*")
  else
    GIT_VERSION="v0.0.0"
  fi

  # Grab the git-describe long version - <tag>-<#commits>-g<hash>
  # e.g. v1.0.1-1-g91ff3f3
  if ! git describe --dirty --tags --long > /dev/null 2>&1; then
    GIT_DESCRIBE=$(git describe --dirty --tags --long)
  else
    GIT_DESCRIBE="-"
  fi
}

# BEGIN TEXT FOMATTING - COLORED
ESC_RED="\e[31m"
ESC_BRIGHT_RED="\u001b[31;1m"
ESC_LIGHT_PURPLE="\u001b[1;35m"
ESC_WHITE="\e[37m"
ESC_YELLOW="\e[33m"
ESC_GREEN="\e[92m"
ESC_CYAN="\e[96m"
ESC_BOLD="\e[1m"
ESC_ITALIC="\e[3m"
ESC_RESET="\e[0m"

print_bold() { printf "${ESC_BOLD}$*${ESC_RESET}\n"; }
print_italic() { printf "${ESC_ITALIC}$*${ESC_RESET}\n"; }
print_green() { printf "${ESC_GREEN}$*${ESC_RESET}\n"; }
print_red() { printf "${ESC_RED}$*${ESC_RESET}\n"; }
print_yellow() { printf "${ESC_YELLOW}$*${ESC_RESET}\n"; }
print_cyan() { printf "${ESC_CYAN}$*${ESC_RESET}\n"; }

print_debug() {
  if [ "${DEBUG:-0}" == 0 ]; then :;return; fi
  printf "${ESC_LIGHT_PURPLE}$*${ESC_RESET}\n";
}
print_info() { printf "${ESC_WHITE}$*${ESC_RESET}\n"; }
print_warning() { printf "${ESC_YELLOW}$*${ESC_RESET}\n"; }
print_error() { >&2 printf "${ESC_RED}$*${ESC_RESET}\n"; }
print_critical() { >&2 printf "${ESC_BRIGHT_RED}$*${ESC_RESET}\n"; }

print_header() { printf "${ESC_WHITE}${ESC_BOLD}$*${ESC_RESET}\n"; }
print_body() { printf "${ESC_WHITE}$*${ESC_RESET}\n"; }
print_caption() { printf "${ESC_WHITE}${ESC_ITALIC}$*${ESC_RESET}\n"; }
print_help() { printf "${ESC_CYAN}$*${ESC_RESET}\n"; }
print_success() { printf "${ESC_GREEN}$*${ESC_RESET}\n"; }
print_failure() { >&2 printf "${ESC_RED}${ESC_BOLD}$*${ESC_RESET}\n"; }
# END TEXT FOMATTING - COLORED


# Show help dialog to user 
usage() {
  print_help "$(cat << EOF
Usage:
  $0 [-h]

Options:
  -h        show help                        [boolean]

Examples:
  $0                            
EOF
  )"
}


# On finish, show success or failure depending on the exit code
trap "finish" EXIT
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM
finish() {
  local exit_code="$?"

  if [ "$exit_code" != "0" ]; then
    echo ""
    usage
    echo ""
    print_failure "$0 failed with code $exit_code"
  else
    echo ""
    print_success "$0 succeeded"
    echo ""
  fi
  exit $exit_code
}

# Read in user options and positional arguments
read_args() {
  # Outer loop handles positional arguments
  POSITIONAL_ARGS=()
  while [ $# -gt 0 ]; do
    unset OPTIND
    unset OPTARG

    # Inner loop handles options
    # :abc:e:f: -> abc no arguments, cef read arguments into OPTARG
    while getopts ":hu:" opt; do
      case $opt in
        h)
          usage
          exit 0
          ;;
        u)
          echo "Option $opt set with value: $OPTARG"
          ;;
        ':')
          print_error "Missing argument for option -- ${OPTARG:-optarg-missing}" >&2
          exit 1
          ;;
        \?)
          print_error "Unknown option -- ${OPTARG:-optarg-missing}" >&2
          exit 1
          ;;
        *)
          print_error "Unimplemented option -- ${opt}" >&2
          exit 1
          ;;
        esac
      done
      shift $((OPTIND-1))

      # Gather positional arguments. Conditional prevents unset $1 variable issues
      if [ -z ${1+x} ]; then
        :
      else
        POSITIONAL_ARGS+=("$1")
        shift
      fi
    done

    print_body "Positional Args: ${POSITIONAL_ARGS[*]}"
}


# Begins script execution
run() {
  print_header "Running $0 ..."
  ################ Write your script here! ################
  # ...
}

setup
read_args "$@"
run

