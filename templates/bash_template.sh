#!/usr/bin/env bash
###################################################################
# Script Name       : <SCRIPTIT_SCRIPT_NAME>
# Description       : <description>
# Author       	    : <anonymous>                                                
# Email             : <anoymous@gmail.com> 
###################################################################

# Setup script
setup() {
  :
### BEGIN SCRIPTIT_TOGGLE_UNOFFCIAL_BASH_STRICT_MODE
### END SCRIPTIT_TOGGLE_UNOFFCIAL_BASH_STRICT_MODE

### BEGIN SCRIPTIT_TOGGLE_SCRIPT_DIR
### END SCRIPTIT_TOGGLE_SCRIPT_DIR

### BEGIN SCRIPTIT_TOGGLE_GIT
### END SCRIPTIT_TOGGLE_GIT
}

### BEGIN SCRIPTIT_TOGGLE_FORMAT_TEXT_COLOR
### END SCRIPTIT_TOGGLE_FORMAT_TEXT_COLOR


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

### BEGIN SCRIPTIT_TOGGLE_PARSE_ARGS
### END SCRIPTIT_TOGGLE_PARSE_ARGS
### BEGIN SCRIPTIT_TOGGLE_YAML_PARSER
### END SCRIPTIT_TOGGLE_YAML_PARSER

# Begins script execution
run() {
  print_header "Running $0 ..."
  ################ Write your script here! ################
  # ...
}

setup
### BEGIN SCRIPTIT_NAME_PARSE_ARGS
### END SCRIPTIT_NAME_PARSE_ARGS
run

