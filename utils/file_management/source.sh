#!/bin/bash
#
# File management utility functions for shell scripts.

#######################################
# Ensure a file exists before continuing.
# Globals:
#   None
# Arguments:
#   $1: File path to check.
# Outputs:
#   None
# Returns:
#   0 if the file exists.
#   1 if the file is not found.
#######################################
require_file() {
  local file="$1"

  if [[ ! -f "$file" ]]; then
    fail "Expected file not found: $file"
  fi
}

#######################################
# Ensure a directory exists before continuing.
# Globals:
#   None
# Arguments:
#   $1: Directory path to check.
# Outputs:
#   None
# Returns:
#   0 if the directory exists.
#   1 if the directory is not found.
#######################################
require_dir() {
  local dir="$1"

  if [[ ! -d "$dir" ]]; then
    fail "Expected directory not found: $dir"
  fi
}

#######################################
# Copy a file from source to destination if destination doesn't exist.
# Globals:
#   None
# Arguments:
#   $1: Source file path.
#   $2: Destination file path.
# Outputs:
#   Writes log messages to stdout.
# Returns:
#   0 on success.
#   1 if source is missing or destination path is taken by non-regular file.
#######################################
copy_file_if_missing() {
  local src="$1"
  local dest="$2"

  [[ -f "$src" ]] || fail "Source file is missing: $src"

  if [[ -f "$dest" ]]; then
    log "File exists, leaving unchanged: $dest"
    return 0
  fi

  if [[ -e "$dest" ]]; then
    fail "Path exists but is not a regular file: $dest"
  fi

  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  log "Created file: $dest"
}

#######################################
# Ensure a directory exists, creating it if necessary.
# Globals:
#   None
# Arguments:
#   $1: Directory path to check/create.
# Outputs:
#   Writes log messages to stdout.
# Returns:
#   0 on success.
#   1 if path exists but is not a directory.
#######################################
ensure_dir() {
  local dir="$1"

  if [[ -d "$dir" ]]; then
    return 0
  fi

  if [[ -e "$dir" ]]; then
    fail "Path exists but is not a directory: $dir"
  fi

  mkdir -p "$dir"
  log "Created directory: $dir"
}

#######################################
# Print a tree view of a directory.
# Globals:
#   None
# Arguments:
#   $1: Directory path to display.
#   $2: Depth of tree to display.
# Outputs:
#   Writes directory tree to stdout.
# Returns:
#   0 on success or if tree command not found.
#   1 if invalid number of arguments provided.
#######################################
print_dir_tree() {
  if [ $# -ne 2 ]; then
    log "Warning: Invalid number of arguments. Expected 2, but got $#. Usage: print_dir_tree <directory> <depth>"
    return 1
  fi

  if command -v tree &> /dev/null; then
    local DIRECTORY="$1"
    local DEPTH="$2"
    log "Directory tree:"
    tree -a -L $DEPTH "$DIRECTORY"
  else
    log "Warning: 'tree' command not found, please install it to inspect the directory structure"
  fi
}

#######################################
# Execute a command from a different directory.
# Globals:
#   None
# Arguments:
#   $1: Directory to execute command from.
#   $@: Command and its arguments to execute.
# Outputs:
#   Outputs from the executed command.
# Returns:
#   Exit status of the executed command.
#######################################
run_in_dir() {
  local dir="$1"
  require_dir "$dir"

  shift

  (
    cd "$dir" || {
      fail "Could not cd into $dir"
    }

    "$@"
  )
}