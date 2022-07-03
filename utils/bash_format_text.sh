# BEGIN TEXT FOMATTING - UNCOLORED
print_debug() { 
  if [ "${DEBUG:-0}" == 0 ]; then :;return; fi
  printf "$*\n";
}
print_info() { printf "$*\n"; }
print_warning() { printf "$*\n"; }
print_error() { printf "$*\n"; }
print_critical() { printf "$*\n"; }

print_header() { printf "$*\n"; }
print_body() { printf "> $*\n"; }
print_caption() { printf "  > $*\n"; }
print_help() { printf "$*\n"; }
print_success() { printf "$*\n"; }
print_failure() { printf "$*\n"; }
# END TEXT FOMATTING - UNCOLORED
