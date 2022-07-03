#!/usr/bin/env bash
###################################################################
# Script Name       : scriptit.sh
# Description       : Bash cookiecutter
# Author       	    : onescriptkid                                                
# Email             : onescriptkid@gmail.com
# Bash versioh      : GNU bash, version 5.0.17(1)-release
# Perl version      : v5.30.0
###################################################################


# Setup unofficial bash strictmode, script_dir, and color formatting
setup() {
  set -euo pipefail

  # Get script directory
  SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

  # Get color formatting
  . "$SCRIPT_DIR/utils/bash_format_text_color.sh"
}


# Print help
usage() {
  print_cyan "$(cat << EOF
Usage:
  $0 [-hvsd] [-udgcapwy 0|1] <script-name>

Options:
  -h        show help                        [boolean]
  -v        show version                     [boolean]
  -s        skip prompt. use defaults        [boolean]
  -d        debug mode                       [boolean]

  -u        unoffical bash strictmode        [number] [required]    
  -S        include script_dir               [number] [required]
  -g        include git_repo_dir             [number] [required]
  -c        include hues|colors|font         [number] [required]
  -a        include parse_args               [number] [required]
  -y        include a yaml parser            [number] [required]

Examples:
  $0 -s build.sh                           skips prompts. generates script quickly using defaults
  $0 -a0 build.sh                          create a script without parse_args 
  $0 -h                                    shows help
  $0 -u1 -S1 -g1 -c1 -a1 -y1 build.sh      give me everything overzealously

CopyPasta:
  $0 -s build.sh
EOF
  )"
}


# Upon finish, show success or failure depending on the exit code
trap "finish" EXIT
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM
finish() {
  local exit_code="$?"

  if [ "$exit_code" != "0" ]; then
    print_info ""
    usage
    print_info ""
    print_failure "$0 failed with code $exit_code"
  else
    print_info ""
    helpful_tip
    print_info ""
  fi
  exit $exit_code
}


# Read in user options and positional arguments
# - FLAG_SET_* is set if the user overrides the default
# - OPTION_*   is the value the user uses to override
# - ARG_SET_* is set if the user sets a positional argument
read_args() {
  # Outer loop handles positional arguments
  POSITIONAL_ARGS=()
  while [ $# -gt 0 ]; do
    unset OPTIND
    unset OPTARG

    # Inner loop handles options
    while getopts ":hvdsu:S:g:c:a:p:" opt; do
      case $opt in
        h)
          usage
          exit 0
          ;;
        v)
          printf "no version set\n"
          exit 0
          ;;
        s)
          FLAG_SET_SCRIPTIT_SKIP_PROMPTS=1
          OPTION_SCRIPTIT_SKIP_PROMPTS=1
          ;;
        d)
          FLAG_SET_SCRIPTIT_DEBUG=1
          OPTION_SCRIPTIT_DEBUG=1
          ;;
        u)
          if [ "$OPTARG" != "0" ] && [ "$OPTARG" != "1" ]; then print_error "Option -${opt} should be <0|1> not $OPTARG"; exit 1; fi
          OPTION_SCRIPTIT_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE="$OPTARG"
          FLAG_SET_SCRIPTIT_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE=1
          ;;
        S)
          if [ "$OPTARG" != "0" ] && [ "$OPTARG" != "1" ]; then print_error "Option -${opt} should be <0|1> not $OPTARG"; exit 1; fi
          OPTION_SCRIPTIT_TOGGLE_SCRIPT_DIR="$OPTARG"
          FLAG_SET_SCRIPTIT_TOGGLE_SCRIPT_DIR=1
          ;;
        g)
          if [ "$OPTARG" != "0" ] && [ "$OPTARG" != "1" ]; then print_error "Option -${opt} should be <0|1> not $OPTARG"; exit 1; fi
          OPTION_SCRIPTIT_TOGGLE_GIT="$OPTARG"
          FLAG_SET_SCRIPTIT_TOGGLE_GIT=1
          ;;
        c)
          if [ "$OPTARG" != "0" ] && [ "$OPTARG" != "1" ]; then print_error "Option -${opt} should be <0|1> not $OPTARG"; exit 1; fi
          OPTION_SCRIPTIT_TOGGLE_FORMAT_TEXT="$OPTARG"
          FLAG_SET_SCRIPTIT_TOGGLE_FORMAT_TEXT=1
          ;;
        a)
          if [ "$OPTARG" != "0" ] && [ "$OPTARG" != "1" ]; then print_error "Option -${opt} should be <0|1> not $OPTARG"; exit 1; fi
          OPTION_SCRIPTIT_TOGGLE_PARSE_ARGS="$OPTARG"
          FLAG_SET_SCRIPTIT_TOGGLE_PARSE_ARGS=1
          ;;
        p)
          if [ "$OPTARG" != "0" ] && [ "$OPTARG" != "1" ]; then print_error "Option -${opt} should be <0|1> not $OPTARG"; exit 1; fi
          OPTION_SCRIPTIT_TOGGLE_PROGRESS_BAR="$OPTARG"
          FLAG_SET_SCRIPTIT_TOGGLE_PROGRESS_BAR=1
          print_error "progress_bar to be implemented in a future version"
          exit 1
          ;;
        y)
          if [ "$OPTARG" != "0" ] && [ "$OPTARG" != "1" ]; then print_error "Option -${opt} should be <0|1> not $OPTARG"; exit 1; fi
          OPTION_SCRIPTIT_TOGGLE_YAML_PARSER="$OPTARG"
          FLAG_SET_SCRIPTIT_TOGGLE_YAML_PARSER=1
          print_error "yaml_parser to be implemented in a future version"
          exit 1
          ;;
        w)
          if [ "$OPTARG" != "0" ] && [ "$OPTARG" != "1" ]; then print_error "Option -${opt} should be <0|1> not $OPTARG"; exit 1; fi
          FLAG_SET_SCRIPTIT_TOGGLE_WAIT_FOR_IT=1
          OPTION_SCRIPTIT_TOGGLE_WAIT_FOR_IT="$OPTARG"
          print_error "wait-for-it to be implemented in a future version"
          exit 1
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
        ARG_SET_SCRIPTIT_SCRIPT_NAME=1
        POSITIONAL_ARGS+=("$1")
        shift
      fi
    done

  # Handle positional args
  # > 1 Error if there's more than 1 pos arg for scriptname - unittest.sh compile.sh transpile.sh
  # = 0 Show warning if there's no positional argument set - Use default scriptname
  # = 1 Set to the user defined positional argument 
  # There shouldn't be more than 1 positional argument, it's reserved for the scriptname!
  if [ ${#POSITIONAL_ARGS[@]} -gt 1  ]; then
    print_error "There should only be 1 positional argument. Found -- ${POSITIONAL_ARGS[*]}"
    exit 1
  elif [ ${#POSITIONAL_ARGS[@]} -eq 0 ]; then
    SCRIPTIT_SCRIPT_NAME=$DEFAULT_SCRIPTIT_SCRIPT_NAME
  else
    SCRIPTIT_SCRIPT_NAME=${POSITIONAL_ARGS[0]}
  fi

  # Set global template variables according to the incoming options set by the user
  SCRIPTIT_SKIP_PROMPTS=${OPTION_SCRIPTIT_SKIP_PROMPTS:-$DEFAULT_SCRIPTIT_SKIP_PROMPTS}
  SCRIPTIT_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE=${OPTION_SCRIPTIT_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE:-$DEFAULT_SCRIPTIT_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE}
  SCRIPTIT_TOGGLE_SCRIPT_DIR=${OPTION_SCRIPTIT_TOGGLE_SCRIPT_DIR:-$DEFAULT_SCRIPTIT_TOGGLE_SCRIPT_DIR}
  SCRIPTIT_TOGGLE_GIT=${OPTION_SCRIPTIT_TOGGLE_GIT:-$DEFAULT_SCRIPTIT_TOGGLE_GIT}
  SCRIPTIT_TOGGLE_FORMAT_TEXT=${OPTION_SCRIPTIT_TOGGLE_FORMAT_TEXT:-$DEFAULT_SCRIPTIT_TOGGLE_FORMAT_TEXT}
  SCRIPTIT_TOGGLE_YAML_PARSER=${OPTION_SCRIPTIT_TOGGLE_YAML_PARSER:-$DEFAULT_SCRIPTIT_TOGGLE_YAML_PARSER}
  SCRIPTIT_TOGGLE_PARSE_ARGS=${OPTION_SCRIPTIT_TOGGLE_PARSE_ARGS:-$DEFAULT_SCRIPTIT_TOGGLE_PARSE_ARGS}
  SCRIPTIT_TOGGLE_PROGRESS_BAR=${OPTION_SCRIPTIT_TOGGLE_PROGRESS_BAR:-$DEFAULT_SCRIPTIT_TOGGLE_PROGRESS_BAR}
  SCRIPTIT_TOGGLE_WAIT_FOR_IT=${OPTION_SCRIPTIT_TOGGLE_WAIT_FOR_IT:-$DEFAULT_SCRIPTIT_TOGGLE_WAIT_FOR_IT}
  DEBUG=${OPTION_SCRIPTIT_DEBUG:-$DEFAULT_SCRIPTIT_DEBUG}

  # DEBUG - Show template variables for debugging
  print_debug "Template variables set by user or using defaults as a fallback"
  print_debug "SCRIPTIT_SKIP_PROMPTS=                               $SCRIPTIT_SKIP_PROMPTS"
  print_debug "SCRIPTIT_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE=         $SCRIPTIT_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE"
  print_debug "SCRIPTIT_TOGGLE_SCRIPT_DIR=                          $SCRIPTIT_TOGGLE_SCRIPT_DIR"
  print_debug "SCRIPTIT_TOGGLE_GIT=                                 $SCRIPTIT_TOGGLE_GIT"
  print_debug "SCRIPTIT_TOGGLE_FORMAT_TEXT=                         $SCRIPTIT_TOGGLE_FORMAT_TEXT"
  print_debug "SCRIPTIT_TOGGLE_PARSE_ARGS=                          $SCRIPTIT_TOGGLE_PARSE_ARGS"
  print_debug "SCRIPTIT_TOGGLE_YAML_PARSER=                         $SCRIPTIT_TOGGLE_YAML_PARSER"
  print_debug "SCRIPTIT_SCRIPT_NAME=                                $SCRIPTIT_SCRIPT_NAME"
  print_debug "DEBUG=                                               $DEBUG"
  print_debug ""

  print_debug "Flags"
  print_debug "FLAG_SET_SCRIPTIT_SKIP_PROMPTS=                       $FLAG_SET_SCRIPTIT_SKIP_PROMPTS"
  print_debug "FLAG_SET_SCRIPTIT_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE= $FLAG_SET_SCRIPTIT_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE"
  print_debug "FLAG_SET_SCRIPTIT_TOGGLE_SCRIPT_DIR=                  $FLAG_SET_SCRIPTIT_TOGGLE_SCRIPT_DIR"
  print_debug "FLAG_SET_SCRIPTIT_TOGGLE_GIT=                         $FLAG_SET_SCRIPTIT_TOGGLE_GIT"
  print_debug "FLAG_SET_SCRIPTIT_TOGGLE_FORMAT_TEXT=                 $FLAG_SET_SCRIPTIT_TOGGLE_FORMAT_TEXT"
  print_debug "FLAG_SET_SCRIPTIT_TOGGLE_PARSE_ARGS=                  $FLAG_SET_SCRIPTIT_TOGGLE_PARSE_ARGS"
  print_debug "FLAG_SET_SCRIPTIT_TOGGLE_YAML_PARSER=                 $FLAG_SET_SCRIPTIT_TOGGLE_YAML_PARSER"
  print_debug "DEBUG=                                                $DEBUG"
  print_debug "ARG_SET_SCRIPTIT_SCRIPT_NAME=                         $ARG_SET_SCRIPTIT_SCRIPT_NAME"

}


# Set default values for template variables
set_defaults() {
  DEFAULT_SCRIPTIT_SKIP_PROMPTS=0
  DEFAULT_SCRIPTIT_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE=1
  DEFAULT_SCRIPTIT_TOGGLE_SCRIPT_DIR=1
  DEFAULT_SCRIPTIT_TOGGLE_GIT=1
  DEFAULT_SCRIPTIT_TOGGLE_FORMAT_TEXT=1
  DEFAULT_SCRIPTIT_TOGGLE_PARSE_ARGS=1
  DEFAULT_SCRIPTIT_TOGGLE_PROGRESS_BAR=0
  DEFAULT_SCRIPTIT_TOGGLE_WAIT_FOR_IT=0
  DEFAULT_SCRIPTIT_TOGGLE_YAML_PARSER=0
  DEFAULT_SCRIPTIT_SCRIPT_NAME="scriptit_script.sh"
  DEFAULT_SCRIPTIT_DEBUG=0

  FLAG_SET_SCRIPTIT_SKIP_PROMPTS=0
  FLAG_SET_SCRIPTIT_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE=0
  FLAG_SET_SCRIPTIT_TOGGLE_SCRIPT_DIR=0
  FLAG_SET_SCRIPTIT_TOGGLE_GIT=0
  FLAG_SET_SCRIPTIT_TOGGLE_FORMAT_TEXT=0
  FLAG_SET_SCRIPTIT_TOGGLE_PARSE_ARGS=0
  FLAG_SET_SCRIPTIT_TOGGLE_YAML_PARSER=0
  ARG_SET_SCRIPTIT_SCRIPT_NAME=0
  FLAG_SET_SCRIPTIT_DEBUG=0
}


# Prompt the user for what should be included in their bash script - script_dir, git, argparsing, etc
# - If a user sets skip prompts, skip prompts
# - If a user set a flag already, skip that prompt.
prompts() {
  print_debug ""

  # Should we skip prompts?
  if [ "$SCRIPTIT_SKIP_PROMPTS" == 1 ]; then
    print_debug "Skipping prompts ..."
    return
  fi

  # Should we add bash unofficial strict mode?
  if [ "$FLAG_SET_SCRIPTIT_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE" == 0 ] ; then
    print_bold "📁 Do you want $(print_italic unoffical bash strict mode)?"
    while true; do
      read -r -n1 -p "Type $(print_italic y) / $(print_italic n): " input
      case $input in
        [nN]* )
          SCRIPTIT_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE=0
          break
          ;;
        [yY]*)
          SCRIPTIT_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE=1
          break
        ;;
      esac
      echo ""
    done
    echo ""
  fi

  # Should we add a script_dir
  if [ "$FLAG_SET_SCRIPTIT_TOGGLE_SCRIPT_DIR" == 0 ] ; then
    print_bold "🔨  Do you want $(print_italic SCRIPT_DIR)?"
    while true; do
      read -r -n1 -p "Type $(print_italic y) / $(print_italic n): " input
      case $input in
        [nN]* )
          SCRIPTIT_TOGGLE_SCRIPT_DIR=0
          break
          ;;
        [yY]*)
          SCRIPTIT_TOGGLE_SCRIPT_DIR=1
          break
        ;;
      esac
      echo ""
    done
    echo ""
  fi

  # Should we add a git references - GIT_REPO, COMMIT_HASH, and BRANCH?
  if [ "$FLAG_SET_SCRIPTIT_TOGGLE_GIT" == 0 ]; then
    print_bold "🎄 Is this script in a $(print_italic git repo)?"
    while true; do
      read -r -n1 -p "Type $(print_italic y) / $(print_italic n): " input
      case $input in
        [nN]* )
          SCRIPTIT_TOGGLE_GIT=0
          break
          ;;
        [yY]*)
          SCRIPTIT_TOGGLE_GIT=1
          break
        ;;
      esac
      echo ""
    done
    echo ""
  fi

  # Should we add colored output?
  if [ "$FLAG_SET_SCRIPTIT_TOGGLE_FORMAT_TEXT" == 0 ]; then
    print_bold "🎨 Do you want colored output?"
    while true; do
      read -r -n1 -p "Type $(print_italic y) / $(print_italic n): " input
      case $input in
        [nN]* )
          SCRIPTIT_TOGGLE_FORMAT_TEXT=0
          break
          ;;
        [yY]*)
          SCRIPTIT_TOGGLE_FORMAT_TEXT=1
          break
        ;;
      esac
      echo ""
    done
    echo ""
  fi

  # Should we add argument and option parsing?
  if [ "$FLAG_SET_SCRIPTIT_TOGGLE_PARSE_ARGS" == 0 ]; then
    print_bold "🤖 Do you want arg and option parsing?"
    while true; do
      read -r -n1 -p "Type $(print_italic y) / $(print_italic n): " input
      case $input in
        [nN]* )
          SCRIPTIT_TOGGLE_FORMAT_TEXT=0
          break
          ;;
        [yY]*)
          SCRIPTIT_TOGGLE_FORMAT_TEXT=1
          break
        ;;
      esac
      echo ""
    done
    echo ""
  fi

  # Should we add a shell only yaml parser?
  if [ "$FLAG_SET_SCRIPTIT_TOGGLE_YAML_PARSER" == 0 ]; then
    print_bold "⭐ Do you want yaml parsing?"
    while true; do
      read -r -n1 -p "Type $(print_italic y) / $(print_italic n): " input
      case $input in
        [nN]* )
          SCRIPTIT_TOGGLE_YAML_PARSER=0
          break
          ;;
        [yY]*)
          SCRIPTIT_TOGGLE_YAML_PARSER=1
          break
        ;;
      esac
      echo ""
    done
    echo ""
  fi

  # DEBUG
  print_debug "SCRIPTIT_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE= $SCRIPTIT_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE"
  print_debug "SCRIPTIT_TOGGLE_SCRIPT_DIR= $SCRIPTIT_TOGGLE_SCRIPT_DIR"
  print_debug "SCRIPTIT_TOGGLE_GIT= $SCRIPTIT_TOGGLE_GIT"
  print_debug "SCRIPTIT_TOGGLE_FORMAT_TEXT= $SCRIPTIT_TOGGLE_FORMAT_TEXT"
  print_debug "SCRIPTIT_TOGGLE_PARSE_ARGS= $SCRIPTIT_TOGGLE_PARSE_ARGS"
  print_debug "SCRIPTIT_TOGGLE_YAML_PARSER= $SCRIPTIT_TOGGLE_YAML_PARSER"
}

create_scratch_directory(){
  SCRATCH="$(mktemp -d -t scriptit-XXXXXXXXXX)"
  chmod 755 "$SCRATCH"
  print_debug "Creating scratch dir $SCRATCH"
}

generate_script(){
  print_debug "Generating script from template.."

  # Save original directory to later output script to correct location
  ORIGINAL_DIR=$(pwd)
  pushd "$SCRATCH" > /dev/null

  # Copy bash_template to scratch directory
  cp "$SCRIPT_DIR/templates/bash_template.sh" "$SCRATCH"/"$SCRIPTIT_SCRIPT_NAME"

  # Apply bash strict mode
  SCRIPTIT_0=$(<"$SCRIPT_DIR/utils/bash_unofficial_bash_strictmode.sh")
  export SCRIPTIT_0
  perl -0pi -e 'BEGIN{undef $/;} s/### BEGIN SCRIPTIT_TOGGLE_UNOFFCIAL_BASH_STRICT_MODE.*### END SCRIPTIT_TOGGLE_UNOFFCIAL_BASH_STRICT_MODE/$ENV{SCRIPTIT_0}/smg' "$SCRATCH"/"$SCRIPTIT_SCRIPT_NAME"

  # Apply script_dir
  SCRIPTIT_1=$(<"$SCRIPT_DIR/utils/bash_script_dir.sh")
  export SCRIPTIT_1
  perl -0pi -e 'BEGIN{undef $/;} s/### BEGIN SCRIPTIT_TOGGLE_SCRIPT_DIR.*### END SCRIPTIT_TOGGLE_SCRIPT_DIR/$ENV{SCRIPTIT_1}/smg' "$SCRATCH"/"$SCRIPTIT_SCRIPT_NAME"

  # Apply git
  SCRIPTIT_2=$(<"$SCRIPT_DIR/utils/bash_git.sh")
  export SCRIPTIT_2
  perl -0pi -e 'BEGIN{undef $/;} s/### BEGIN SCRIPTIT_TOGGLE_GIT.*### END SCRIPTIT_TOGGLE_GIT/$ENV{SCRIPTIT_2}/smg' "$SCRATCH"/"$SCRIPTIT_SCRIPT_NAME"

  # Apply colors
  SCRIPTIT_3=$(<"$SCRIPT_DIR/utils/bash_format_text_color.sh")
  export SCRIPTIT_3
  perl -0pi -e 'BEGIN{undef $/;} s/### BEGIN SCRIPTIT_TOGGLE_FORMAT_TEXT_COLOR.*### END SCRIPTIT_TOGGLE_FORMAT_TEXT_COLOR/$ENV{SCRIPTIT_3}/smg' "$SCRATCH"/"$SCRIPTIT_SCRIPT_NAME"

  # Apply parse_args
  SCRIPTIT_4=$(<"$SCRIPT_DIR/utils/bash_parse_args.sh")
  export SCRIPTIT_4
  perl -0pi -e 'BEGIN{undef $/;} s/### BEGIN SCRIPTIT_TOGGLE_PARSE_ARGS.*### END SCRIPTIT_TOGGLE_PARSE_ARGS/$ENV{SCRIPTIT_4}/smg' "$SCRATCH"/"$SCRIPTIT_SCRIPT_NAME"

  # Apply parse_args part 2
  perl -0pi -e 'BEGIN{undef $/;} s/### BEGIN SCRIPTIT_NAME_PARSE_ARGS.*### END SCRIPTIT_NAME_PARSE_ARGS/read_args \"\$@\"/smg' "$SCRATCH"/"$SCRIPTIT_SCRIPT_NAME"

  # Apply yaml parser
  SCRIPTIT_5=$(<"$SCRIPT_DIR/utils/bash_yaml_parser.sh")
  export SCRIPTIT_5
  perl -0pi -e 'BEGIN{undef $/;} s/### BEGIN SCRIPTIT_TOGGLE_YAML_PARSER.*### END SCRIPTIT_TOGGLE_YAML_PARSER/$ENV{SCRIPTIT_5}/smg' "$SCRATCH"/"$SCRIPTIT_SCRIPT_NAME"

  # If a user set the scriptname, copy the script
  SCRIPTIT_OUTPUT=""
  if [ "$ARG_SET_SCRIPTIT_SCRIPT_NAME" == 1 ]; then
    SCRIPTIT_OUTPUT="$ORIGINAL_DIR"/"$SCRIPTIT_SCRIPT_NAME"
    cp -a "$SCRATCH"/"$SCRIPTIT_SCRIPT_NAME" "$SCRIPTIT_OUTPUT"
  else
    SCRIPTIT_OUTPUT="$SCRATCH/$SCRIPTIT_SCRIPT_NAME"
  fi

  # Make the script executable
  chmod 755 "$SCRIPTIT_OUTPUT" 

  popd > /dev/null
}

helpful_tip() {
  # Show helpful tip
  print_success "Created script:"
  print_body ""
  print_cyan "\t$SCRIPTIT_OUTPUT"
}

setup
set_defaults
read_args "$@"
prompts
create_scratch_directory
generate_script
