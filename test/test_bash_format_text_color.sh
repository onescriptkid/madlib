#!/usr/bin/env bash
set -euo pipefail

setup () {
  echo "setup"

  # Enter the git repo
  GIT_REPO=$(git rev-parse --show-toplevel)

  echo ""
}

run() {
    echo "Test hues.sh"
    echo ""
    . "$GIT_REPO"/utils/bash_format_text_color.sh

    echo "print_bold       $(print_bold print_bold)"
    echo "print_italic     $(print_italic print_italic)"
    echo ""
    echo "print_cyan       $(print_cyan print_cyan)"
    echo "print_green      $(print_green print_green)"
    echo "print_red        $(print_red print_red)"
    echo "print_yellow     $(print_yellow print_yellow)"
    echo ""
    echo "print_debug      $(print_debug print_debug)"
    echo "print_info       $(print_info print_info)"
    echo "print_warning    $(print_warning print_warning)"
    echo "print_error      $(print_error print_error)"
    echo "print_critical   $(print_critical print_critical)"
    echo ""
    echo "print_header     $(print_header print_header)"
    echo "print_body       $(print_body   print_body)"
    echo "print_caption    $(print_caption print_caption)"
    echo ""
}

setup
run