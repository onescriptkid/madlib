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