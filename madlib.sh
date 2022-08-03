#!/usr/bin/env bash
###################################################################
# Script Name       : madlib.sh
# Description       : Bash cookiecutter
# Author       	    : onescriptkid                                                
# Email             : onescriptkid@gmail.com
# Bash versioh      : GNU bash, version 5.0.17(1)-release
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
          FLAG_SET_MADLIB_SKIP_PROMPTS=1
          OPTION_MADLIB_SKIP_PROMPTS=1
          ;;
        d)
          FLAG_SET_MADLIB_DEBUG=1
          OPTION_MADLIB_DEBUG=1
          ;;
        u)
          if [ "$OPTARG" != "0" ] && [ "$OPTARG" != "1" ]; then print_error "Option -${opt} should be <0|1> not $OPTARG"; exit 1; fi
          OPTION_MADLIB_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE="$OPTARG"
          FLAG_SET_MADLIB_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE=1
          ;;
        S)
          if [ "$OPTARG" != "0" ] && [ "$OPTARG" != "1" ]; then print_error "Option -${opt} should be <0|1> not $OPTARG"; exit 1; fi
          OPTION_MADLIB_TOGGLE_SCRIPT_DIR="$OPTARG"
          FLAG_SET_MADLIB_TOGGLE_SCRIPT_DIR=1
          ;;
        g)
          if [ "$OPTARG" != "0" ] && [ "$OPTARG" != "1" ]; then print_error "Option -${opt} should be <0|1> not $OPTARG"; exit 1; fi
          OPTION_MADLIB_TOGGLE_GIT="$OPTARG"
          FLAG_SET_MADLIB_TOGGLE_GIT=1
          ;;
        c)
          if [ "$OPTARG" != "0" ] && [ "$OPTARG" != "1" ]; then print_error "Option -${opt} should be <0|1> not $OPTARG"; exit 1; fi
          OPTION_MADLIB_TOGGLE_FORMAT_TEXT="$OPTARG"
          FLAG_SET_MADLIB_TOGGLE_FORMAT_TEXT=1
          ;;
        a)
          if [ "$OPTARG" != "0" ] && [ "$OPTARG" != "1" ]; then print_error "Option -${opt} should be <0|1> not $OPTARG"; exit 1; fi
          OPTION_MADLIB_TOGGLE_PARSE_ARGS="$OPTARG"
          FLAG_SET_MADLIB_TOGGLE_PARSE_ARGS=1
          ;;
        p)
          if [ "$OPTARG" != "0" ] && [ "$OPTARG" != "1" ]; then print_error "Option -${opt} should be <0|1> not $OPTARG"; exit 1; fi
          OPTION_MADLIB_TOGGLE_PROGRESS_BAR="$OPTARG"
          FLAG_SET_MADLIB_TOGGLE_PROGRESS_BAR=1
          print_error "progress_bar to be implemented in a future version"
          exit 1
          ;;
        y)
          if [ "$OPTARG" != "0" ] && [ "$OPTARG" != "1" ]; then print_error "Option -${opt} should be <0|1> not $OPTARG"; exit 1; fi
          OPTION_MADLIB_TOGGLE_YAML_PARSER="$OPTARG"
          FLAG_SET_MADLIB_TOGGLE_YAML_PARSER=1
          print_error "yaml_parser to be implemented in a future version"
          exit 1
          ;;
        w)
          if [ "$OPTARG" != "0" ] && [ "$OPTARG" != "1" ]; then print_error "Option -${opt} should be <0|1> not $OPTARG"; exit 1; fi
          FLAG_SET_MADLIB_TOGGLE_WAIT_FOR_IT=1
          OPTION_MADLIB_TOGGLE_WAIT_FOR_IT="$OPTARG"
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
        ARG_SET_MADLIB_SCRIPT_NAME=1
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
    MADLIB_SCRIPT_NAME=$DEFAULT_MADLIB_SCRIPT_NAME
  else
    MADLIB_SCRIPT_NAME=${POSITIONAL_ARGS[0]}
  fi

  # Set global template variables according to the incoming options set by the user
  MADLIB_SKIP_PROMPTS=${OPTION_MADLIB_SKIP_PROMPTS:-$DEFAULT_MADLIB_SKIP_PROMPTS}
  MADLIB_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE=${OPTION_MADLIB_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE:-$DEFAULT_MADLIB_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE}
  MADLIB_TOGGLE_SCRIPT_DIR=${OPTION_MADLIB_TOGGLE_SCRIPT_DIR:-$DEFAULT_MADLIB_TOGGLE_SCRIPT_DIR}
  MADLIB_TOGGLE_GIT=${OPTION_MADLIB_TOGGLE_GIT:-$DEFAULT_MADLIB_TOGGLE_GIT}
  MADLIB_TOGGLE_FORMAT_TEXT=${OPTION_MADLIB_TOGGLE_FORMAT_TEXT:-$DEFAULT_MADLIB_TOGGLE_FORMAT_TEXT}
  MADLIB_TOGGLE_YAML_PARSER=${OPTION_MADLIB_TOGGLE_YAML_PARSER:-$DEFAULT_MADLIB_TOGGLE_YAML_PARSER}
  MADLIB_TOGGLE_PARSE_ARGS=${OPTION_MADLIB_TOGGLE_PARSE_ARGS:-$DEFAULT_MADLIB_TOGGLE_PARSE_ARGS}
  MADLIB_TOGGLE_PROGRESS_BAR=${OPTION_MADLIB_TOGGLE_PROGRESS_BAR:-$DEFAULT_MADLIB_TOGGLE_PROGRESS_BAR}
  MADLIB_TOGGLE_WAIT_FOR_IT=${OPTION_MADLIB_TOGGLE_WAIT_FOR_IT:-$DEFAULT_MADLIB_TOGGLE_WAIT_FOR_IT}
  DEBUG=${OPTION_MADLIB_DEBUG:-$DEFAULT_MADLIB_DEBUG}

  # DEBUG - Show template variables for debugging
  print_debug "Template variables set by user or using defaults as a fallback"
  print_debug "MADLIB_SKIP_PROMPTS=                               $MADLIB_SKIP_PROMPTS"
  print_debug "MADLIB_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE=         $MADLIB_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE"
  print_debug "MADLIB_TOGGLE_SCRIPT_DIR=                          $MADLIB_TOGGLE_SCRIPT_DIR"
  print_debug "MADLIB_TOGGLE_GIT=                                 $MADLIB_TOGGLE_GIT"
  print_debug "MADLIB_TOGGLE_FORMAT_TEXT=                         $MADLIB_TOGGLE_FORMAT_TEXT"
  print_debug "MADLIB_TOGGLE_PARSE_ARGS=                          $MADLIB_TOGGLE_PARSE_ARGS"
  print_debug "MADLIB_TOGGLE_YAML_PARSER=                         $MADLIB_TOGGLE_YAML_PARSER"
  print_debug "MADLIB_SCRIPT_NAME=                                $MADLIB_SCRIPT_NAME"
  print_debug "DEBUG=                                               $DEBUG"
  print_debug ""

  print_debug "Flags"
  print_debug "FLAG_SET_MADLIB_SKIP_PROMPTS=                       $FLAG_SET_MADLIB_SKIP_PROMPTS"
  print_debug "FLAG_SET_MADLIB_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE= $FLAG_SET_MADLIB_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE"
  print_debug "FLAG_SET_MADLIB_TOGGLE_SCRIPT_DIR=                  $FLAG_SET_MADLIB_TOGGLE_SCRIPT_DIR"
  print_debug "FLAG_SET_MADLIB_TOGGLE_GIT=                         $FLAG_SET_MADLIB_TOGGLE_GIT"
  print_debug "FLAG_SET_MADLIB_TOGGLE_FORMAT_TEXT=                 $FLAG_SET_MADLIB_TOGGLE_FORMAT_TEXT"
  print_debug "FLAG_SET_MADLIB_TOGGLE_PARSE_ARGS=                  $FLAG_SET_MADLIB_TOGGLE_PARSE_ARGS"
  print_debug "FLAG_SET_MADLIB_TOGGLE_YAML_PARSER=                 $FLAG_SET_MADLIB_TOGGLE_YAML_PARSER"
  print_debug "DEBUG=                                                $DEBUG"
  print_debug "ARG_SET_MADLIB_SCRIPT_NAME=                         $ARG_SET_MADLIB_SCRIPT_NAME"

}


# Set default values for template variables
set_defaults() {
  DEFAULT_MADLIB_SKIP_PROMPTS=0
  DEFAULT_MADLIB_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE=1
  DEFAULT_MADLIB_TOGGLE_SCRIPT_DIR=1
  DEFAULT_MADLIB_TOGGLE_GIT=1
  DEFAULT_MADLIB_TOGGLE_FORMAT_TEXT=1
  DEFAULT_MADLIB_TOGGLE_PARSE_ARGS=1
  DEFAULT_MADLIB_TOGGLE_PROGRESS_BAR=0
  DEFAULT_MADLIB_TOGGLE_WAIT_FOR_IT=0
  DEFAULT_MADLIB_TOGGLE_YAML_PARSER=0
  DEFAULT_MADLIB_SCRIPT_NAME="madlib_script.sh"
  DEFAULT_MADLIB_DEBUG=0

  FLAG_SET_MADLIB_SKIP_PROMPTS=0
  FLAG_SET_MADLIB_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE=0
  FLAG_SET_MADLIB_TOGGLE_SCRIPT_DIR=0
  FLAG_SET_MADLIB_TOGGLE_GIT=0
  FLAG_SET_MADLIB_TOGGLE_FORMAT_TEXT=0
  FLAG_SET_MADLIB_TOGGLE_PARSE_ARGS=0
  FLAG_SET_MADLIB_TOGGLE_YAML_PARSER=0
  ARG_SET_MADLIB_SCRIPT_NAME=0
  FLAG_SET_MADLIB_DEBUG=0
}


# Prompt the user for what should be included in their bash script - script_dir, git, argparsing, etc
# - If a user sets skip prompts, skip prompts
# - If a user set a flag already, skip that prompt.
prompts() {
  print_debug ""

  # Should we skip prompts?
  if [ "$MADLIB_SKIP_PROMPTS" == 1 ]; then
    print_debug "Skipping prompts ..."
    return
  fi

  # Should we add bash unofficial strict mode?
  if [ "$FLAG_SET_MADLIB_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE" == 0 ] ; then
    print_bold "📁 Do you want $(print_italic unoffical bash strict mode)?"
    while true; do
      read -r -n1 -p "Type $(print_italic y) / $(print_italic n): " input
      case $input in
        [nN]* )
          MADLIB_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE=0
          break
          ;;
        [yY]*)
          MADLIB_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE=1
          break
        ;;
      esac
      echo ""
    done
    echo ""
  fi

  # Should we add a script_dir
  if [ "$FLAG_SET_MADLIB_TOGGLE_SCRIPT_DIR" == 0 ] ; then
    print_bold "🔨  Do you want $(print_italic SCRIPT_DIR)?"
    while true; do
      read -r -n1 -p "Type $(print_italic y) / $(print_italic n): " input
      case $input in
        [nN]* )
          MADLIB_TOGGLE_SCRIPT_DIR=0
          break
          ;;
        [yY]*)
          MADLIB_TOGGLE_SCRIPT_DIR=1
          break
        ;;
      esac
      echo ""
    done
    echo ""
  fi

  # Should we add a git references - GIT_REPO, COMMIT_HASH, and BRANCH?
  if [ "$FLAG_SET_MADLIB_TOGGLE_GIT" == 0 ]; then
    print_bold "🎄 Is this script in a $(print_italic git repo)?"
    while true; do
      read -r -n1 -p "Type $(print_italic y) / $(print_italic n): " input
      case $input in
        [nN]* )
          MADLIB_TOGGLE_GIT=0
          break
          ;;
        [yY]*)
          MADLIB_TOGGLE_GIT=1
          break
        ;;
      esac
      echo ""
    done
    echo ""
  fi

  # Should we add colored output?
  if [ "$FLAG_SET_MADLIB_TOGGLE_FORMAT_TEXT" == 0 ]; then
    print_bold "🎨 Do you want colored output?"
    while true; do
      read -r -n1 -p "Type $(print_italic y) / $(print_italic n): " input
      case $input in
        [nN]* )
          MADLIB_TOGGLE_FORMAT_TEXT=0
          break
          ;;
        [yY]*)
          MADLIB_TOGGLE_FORMAT_TEXT=1
          break
        ;;
      esac
      echo ""
    done
    echo ""
  fi

  # Should we add argument and option parsing?
  if [ "$FLAG_SET_MADLIB_TOGGLE_PARSE_ARGS" == 0 ]; then
    print_bold "🤖 Do you want arg and option parsing?"
    while true; do
      read -r -n1 -p "Type $(print_italic y) / $(print_italic n): " input
      case $input in
        [nN]* )
          MADLIB_TOGGLE_FORMAT_TEXT=0
          break
          ;;
        [yY]*)
          MADLIB_TOGGLE_FORMAT_TEXT=1
          break
        ;;
      esac
      echo ""
    done
    echo ""
  fi

  # Should we add a shell only yaml parser?
  if [ "$FLAG_SET_MADLIB_TOGGLE_YAML_PARSER" == 0 ]; then
    print_bold "⭐ Do you want yaml parsing?"
    while true; do
      read -r -n1 -p "Type $(print_italic y) / $(print_italic n): " input
      case $input in
        [nN]* )
          MADLIB_TOGGLE_YAML_PARSER=0
          break
          ;;
        [yY]*)
          MADLIB_TOGGLE_YAML_PARSER=1
          break
        ;;
      esac
      echo ""
    done
    echo ""
  fi

  # DEBUG
  print_debug "MADLIB_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE= $MADLIB_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE"
  print_debug "MADLIB_TOGGLE_SCRIPT_DIR= $MADLIB_TOGGLE_SCRIPT_DIR"
  print_debug "MADLIB_TOGGLE_GIT= $MADLIB_TOGGLE_GIT"
  print_debug "MADLIB_TOGGLE_FORMAT_TEXT= $MADLIB_TOGGLE_FORMAT_TEXT"
  print_debug "MADLIB_TOGGLE_PARSE_ARGS= $MADLIB_TOGGLE_PARSE_ARGS"
  print_debug "MADLIB_TOGGLE_YAML_PARSER= $MADLIB_TOGGLE_YAML_PARSER"
}

create_scratch_directory(){
  SCRATCH="$(mktemp -d -t madlib-XXXXXXXXXX)"
  chmod 755 "$SCRATCH"
  print_debug "Creating scratch dir $SCRATCH"
}

generate_script_mo(){
  print_debug "Generating script from template (mo).."

  # Save original directory to later output script to correct location
  ORIGINAL_DIR=$(pwd)
  pushd "$SCRATCH" > /dev/null

  # Export script_name to be used in mustache template
  export MADLIB_SCRIPT_NAME

  # Copy bash_template to scratch directory
  set -a
  cp "$SCRIPT_DIR/templates/bash_template.sh.mustache" "$SCRATCH"/"$MADLIB_SCRIPT_NAME"

  # Apply bash strict mode
  if [ "$MADLIB_TOGGLE_UNOFFICIAL_BASH_STRICT_MODE" = "1"  ]; then 
    MADLIB_UNOFFCIAL_BASH_STRICT_MODE_CONTENT=$(<"$SCRIPT_DIR/utils/bash_unofficial_bash_strictmode.sh")
  else
    MADLIB_UNOFFCIAL_BASH_STRICT_MODE_CONTENT=""
  fi

  # Apply script_dir
  if [ "$MADLIB_TOGGLE_SCRIPT_DIR" = "1"  ]; then 
    MADLIB_SCRIPT_DIR_CONTENT=$(<"$SCRIPT_DIR/utils/bash_script_dir.sh")
  else
    MADLIB_SCRIPT_DIR_CONTENT=""
  fi

  # Apply git
  if [ "$MADLIB_TOGGLE_GIT" = "1"  ]; then 
    MADLIB_GIT_CONTENT=$(<"$SCRIPT_DIR/utils/bash_git.sh")
  else
    MADLIB_GIT_CONTENT=""
  fi

  # Apply colors
  if [ "$MADLIB_TOGGLE_FORMAT_TEXT" = "1"  ]; then 
    MADLIB_FORMAT_TEXT_CONTENT=$(<"$SCRIPT_DIR/utils/bash_format_text_color.sh")
  else
    MADLIB_FORMAT_TEXT_CONTENT=$(<"$SCRIPT_DIR/utils/bash_format_text.sh")
  fi

  # Apply parse_args
  if [ "$MADLIB_TOGGLE_PARSE_ARGS" = "1"  ]; then 
    MADLIB_PARSE_ARGS_CONTENT=$(<"$SCRIPT_DIR/utils/bash_parse_args.sh")
  else
    MADLIB_PARSE_ARGS_CONTENT=""
  fi

  # Apply parse_args part 2
  if [ "$MADLIB_TOGGLE_PARSE_ARGS" = "1"  ]; then
    MADLIB_NAME_PARSE_ARGS_CONTENT="read_args \"\$@\""
  else
    MADLIB_NAME_PARSE_ARGS_CONTENT=""
  fi

  # Apply yaml parser
  if [ "$MADLIB_TOGGLE_YAML_PARSER" = "1"  ]; then 
    MADLIB_TOGGLE_YAML_PARSER_CONTENT=$(<"$SCRIPT_DIR/utils/bash_yaml_parser.sh")
  else
    MADLIB_TOGGLE_YAML_PARSER_CONTENT=""
  fi

  # If a user set the scriptname, copy the script
  MADLIB_OUTPUT=""
  if [ "$ARG_SET_MADLIB_SCRIPT_NAME" == 1 ]; then
    MADLIB_OUTPUT="$ORIGINAL_DIR"/"$MADLIB_SCRIPT_NAME"
    cp -a "$SCRATCH"/"$MADLIB_SCRIPT_NAME" "$MADLIB_OUTPUT"
  else
    MADLIB_OUTPUT="$SCRATCH/$MADLIB_SCRIPT_NAME"
  fi

  # Find and replace with mustache templating
  chmod 755 "$SCRIPT_DIR"/mo
  "$SCRIPT_DIR"/mo "$SCRIPT_DIR/templates/bash_template.sh.mustache" > "$MADLIB_OUTPUT"
  set +a

  # Make the script executable
  chmod 755 "$MADLIB_OUTPUT" 

  popd > /dev/null
}

helpful_tip() {
  # Show helpful tip
  print_success "Created script:"
  print_body ""
  print_cyan "\t$MADLIB_OUTPUT"
}

setup
set_defaults
read_args "$@"
prompts
create_scratch_directory
generate_script_mo
