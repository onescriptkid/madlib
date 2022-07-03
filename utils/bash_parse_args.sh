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