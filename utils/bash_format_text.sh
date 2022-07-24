# BEGIN TEXT FOMATTING - UNCOLORED
print_debug() { 
  if [ "${DEBUG:-0}" == 0 ]; then :;return; fi
  printf "$*\n";
}
print_info() { printf "$*\n"; }
print_warning() { printf "$*\n"; }
print_error() { >&2 printf "$*\n"; }
print_critical() { >&2 printf "$*\n"; }

print_header() { printf "$*\n"; }
print_body() { printf "> $*\n"; }
print_caption() { printf "  > $*\n"; }
print_help() { printf "$*\n"; }
print_success() { printf "$*\n"; }
print_failure() { >&2 printf "$*\n"; }
# END TEXT FOMATTING - UNCOLORED
