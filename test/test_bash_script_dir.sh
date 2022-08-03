#!/usr/bin/env bash
set -euo pipefail

setup () {
  echo "setup"

  # Enter the git repo
  GIT_REPO=$(git rev-parse --show-toplevel)

  # Create and Enter the tmp dir
  SCRATCH=$(mktemp -d -t madlib-XXXXXXXXXX)
  pushd "$SCRATCH" > /dev/null

  echo ""
}

begin() {
  echo "begin"
  echo ""
}

test_absolute() {
  echo "test_absolute /tmp/madlib-XXX/script.sh"

  # Setup absolute test
  cat <<- EOF >"$SCRATCH/echo_script_dir"
echo "\$SCRIPT_DIR"

EOF
  cat "$GIT_REPO"/utils/bash_script_dir.sh "$SCRATCH/echo_script_dir" > "$SCRATCH/bash_script_dir.sh" 
  chmod +x "$SCRATCH/bash_script_dir.sh"

  # Determine the realpath
  REALPATH=$(dirname "$(readlink -f "$SCRATCH"/bash_script_dir.sh)")

  echo "REALPATH   is: $REALPATH"
  echo "SCRIPT_DIR is: $("$SCRATCH"/bash_script_dir.sh)"

  # Cleanup
  unset REALPATH
  unset SCRIPT_DIR
  echo ""
}

test_relative() {
  echo "test_relative ../../script.sh"

  # Setup relative test
  cat <<- EOF >"$SCRATCH/echo_script_dir"
echo "\$SCRIPT_DIR"

EOF
  mkdir -p "$SCRATCH/a/b"
  cat "$GIT_REPO"/utils/bash_script_dir.sh "$SCRATCH/echo_script_dir" > "$SCRATCH/bash_script_dir.sh" 
  chmod +x "$SCRATCH/bash_script_dir.sh"
  pushd "$SCRATCH/a/b" > /dev/null

  # Determine the realpath
  REALPATH=$(dirname "$(readlink -f "$SCRATCH"/bash_script_dir.sh)")

  echo "REALPATH   is: $REALPATH"
  echo "SCRIPT_DIR is: $(../../bash_script_dir.sh)"

  # Cleanup
  unset REALPATH
  unset SCRIPT_DIR
  popd > /dev/null
  echo ""
}

test_relative_crazy() {
  echo "test_relative_crazy ../../a/b/../../script.sh"

  # Setup relative test
  cat <<- EOF >"$SCRATCH/echo_script_dir"
echo "\$SCRIPT_DIR"

EOF
  cat "$GIT_REPO"/utils/bash_script_dir.sh "$SCRATCH/echo_script_dir" > "$SCRATCH/bash_script_dir.sh"
  pushd "$SCRATCH/a/b" > /dev/null
  chmod +x "$SCRATCH/bash_script_dir.sh"

  # Determine the realpath
  REALPATH=$(dirname "$(readlink -f "$SCRATCH"/bash_script_dir.sh)")

  echo "REALPATH   is: $REALPATH"
  echo "SCRIPT_DIR is: $(../../a/b/../../bash_script_dir.sh)"

  # Cleanup
  unset REALPATH
  unset SCRIPT_DIR
  popd > /dev/null
  echo ""
}


test_symlink_relative() {
  echo "test_symlink_relative"

  # Setup relative test
  cat <<- EOF >"$SCRATCH/echo_script_dir"
echo "\$SCRIPT_DIR"

EOF
  cat "$GIT_REPO"/utils/bash_script_dir.sh "$SCRATCH/echo_script_dir" > "$SCRATCH/bash_script_dir.sh"
  pushd "$SCRATCH/a/b" > /dev/null
  chmod +x "$SCRATCH/bash_script_dir.sh"

  ln -s ../../bash_script_dir.sh bash_script_dir_relative_symlink.sh

  # Determine the realpath
  REALPATH=$(dirname "$(readlink -f "$SCRATCH"/bash_script_dir.sh)")

  echo "REALPATH   is: $REALPATH"
  echo "SCRIPT_DIR is: $("$SCRATCH"/a/b/bash_script_dir_relative_symlink.sh)"

  # Cleanup
  unset REALPATH
  unset SCRIPT_DIR
  popd > /dev/null
  echo ""
}

test_symlink_absolute() {
  echo "test_symlink_absolute"

  # Setup absolute symlink test
  cat <<- EOF >"$SCRATCH/echo_script_dir"
echo "\$SCRIPT_DIR"

EOF
  cat "$GIT_REPO"/utils/bash_script_dir.sh "$SCRATCH/echo_script_dir" > "$SCRATCH/bash_script_dir.sh"
  pushd "$SCRATCH/a/b" > /dev/null
  chmod +x "$SCRATCH/bash_script_dir.sh"
  ln -s "$SCRATCH"/bash_script_dir.sh "$SCRATCH"/a/b/bash_script_dir_absolute_symlink.sh

  # Determine the realpath
  REALPATH=$(dirname "$(readlink -f "$SCRATCH"/bash_script_dir.sh)")

  echo "REALPATH   is: $REALPATH"
  echo "SCRIPT_DIR is: $("$SCRATCH"/a/b/bash_script_dir_absolute_symlink.sh)"

  # Cleanup
  unset REALPATH
  unset SCRIPT_DIR
  popd > /dev/null
  echo ""
}

test_symlink_to_symlink() {
  echo "test_symlink_to_symlink"

  # Setup relative symlink test
  cat <<- EOF >"$SCRATCH/echo_script_dir"
echo "\$SCRIPT_DIR"

EOF
  cat "$GIT_REPO"/utils/bash_script_dir.sh "$SCRATCH/echo_script_dir" > "$SCRATCH/bash_script_dir.sh"
  mkdir -p "$SCRATCH/a/b/c/d"
  pushd "$SCRATCH/a/b" > /dev/null
  chmod +x "$SCRATCH/bash_script_dir.sh"

  ln -s "$SCRATCH"/bash_script_dir.sh "$SCRATCH"/a/b/bash_script_dir_symlink.sh
  ln -s ../../bash_script_dir_symlink.sh ./c/d/bash_script_dir_symlink_to_symlink.sh

  # Determine the realpath
  REALPATH=$(dirname "$(readlink -f "$SCRATCH"/bash_script_dir.sh)")

  echo "REALPATH   is: $REALPATH"
  echo "SCRIPT_DIR is: $("$SCRATCH"/a/b/c/d/bash_script_dir_symlink_to_symlink.sh)"

  # Cleanup
  unset REALPATH
  unset SCRIPT_DIR
  popd > /dev/null
  echo ""
}

test_space_in_pathname() {
  echo "test_space_in_pathname /abc/d ef/hi/script.sh"

  # Setup space in pathname test
  cat <<- EOF >"$SCRATCH/echo_script_dir"
echo "\$SCRIPT_DIR"

EOF
  mkdir -p "$SCRATCH/abc/d ef/hij"
  cat "$GIT_REPO"/utils/bash_script_dir.sh "$SCRATCH/echo_script_dir" > "$SCRATCH/abc/d ef/hij/bash_script_dir.sh"
  pushd "$SCRATCH/abc/d ef/hij" > /dev/null
  chmod +x "$SCRATCH/abc/d ef/hij/bash_script_dir.sh"

  # Determine the realpath
  REALPATH=$(dirname "$(readlink -f "$SCRATCH"/abc/d\ ef/hij/bash_script_dir.sh)")

  echo "REALPATH   is: $REALPATH"
  echo "SCRIPT_DIR is: $("$SCRATCH/abc/d ef/hij/bash_script_dir.sh")"

  # Cleanup
  unset REALPATH
  unset SCRIPT_DIR
  popd > /dev/null
  echo ""
}

setup
begin
test_absolute
test_relative
test_relative_crazy
test_symlink_relative
test_symlink_absolute
test_symlink_to_symlink
test_space_in_pathname