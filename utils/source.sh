#!/bin/bash
#
# Utility library aggregator that sources additional modules.

# Define this script's absolute path for easier down-sourcing.
UTILS_SOURCE_SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Down-source logging utilities (source first, so down-stream scripts can utilize it).
. "$UTILS_SOURCE_SCRIPT_PATH/logging/source.sh"

# Down-source file management utilities.
. "$UTILS_SOURCE_SCRIPT_PATH/file_management/source.sh"

#######################################
# Require an environment variable to be set.
# Globals:
#   None
# Arguments:
#   $1: Environment variable name to check.
# Outputs:
#   None
# Returns:
#   0 if the environment variable is set.
#   1 if the environment variable is not set.
#######################################
require_var() {
  local var_name="$1"

  if [[ -z "${!var_name:-}" ]]; then
    fail "Environment variable '$var_name' must be set to continue"
  fi
}