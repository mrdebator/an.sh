# mrdebator.zsh-theme - A theme for ZSH
#
# Author: Ansh (mrdebator)
# URL: https://anshc.me/
# --- Enable Zsh Features ---
autoload -Uz vcs_info
autoload -U add-zsh-hook
setopt prompt_subst
# --- Color Definitions ---
# (These remain the same)
ROOT_ICON_COLOR=$FG[111]
MACHINE_NAME_COLOR=$FG[208]
PROMPT_SUCCESS_COLOR=$FG[103]
PROMPT_PROMPT=$FG[208]
GIT_DIRTY_COLOR=$FG[124]
GIT_CLEAN_COLOR=$FG[148]
GIT_PROMPT_INFO=$FG[148]
TIME_COLOR=$FG[242] # A subtle grey for the time

# =======================================================================
# THE CORE LOGIC: Git Status
# =======================================================================
get_git_status_indicator() {
  # Guard Clause: If we are not in a Git repository, return nothing and stop.
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    return
  fi
  # 1. Check for unstaged changes or untracked files.
  # `git diff --quiet` returns a non-zero status if there are unstaged changes.
  # `git ls-files --others --exclude-standard` checks for untracked files.
  if ! git diff --quiet || [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
    echo "%{$GIT_DIRTY_COLOR%}*%{$reset_color%}" # Unstaged changes
    return
  fi
  # 2. If clean, check for staged changes.
  # `git diff --cached --quiet` checks the staging area.
  if ! git diff --cached --quiet; then
    echo "%{$GIT_DIRTY_COLOR%}+%{$reset_color%}" # Staged changes
    return
  fi
  # 3. If staged, check if we are ahead of the remote.
  if git rev-parse @{u} >/dev/null 2>&1; then
    local ahead
    ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null)
    if [[ "$ahead" -gt 0 ]]; then
      echo "%{$GIT_DIRTY_COLOR%}↑%{$reset_color%}" # Needs push
      return
    fi
  fi
  # 4. If all else fails, the repository is clean and synced.
  echo "%{$GIT_CLEAN_COLOR%}✔%{$reset_color%}" # Clean
}

# =======================================================================
# RIGHT PROMPT ALIGNMENT HELPER
# =======================================================================
# This function calculates the spacing needed to right-align content
# It accounts for ANSI escape codes and ensures proper alignment
get_right_aligned_time() {
  # Get the current date/time string
  local datetime_str="$(date '+%d-%b-%Y %H:%M %Z')"

  # Calculate the actual display length (without color codes)
  local datetime_len=${#datetime_str}

  # Get terminal width
  local term_width=$COLUMNS

  # Calculate left side content length (without ANSI codes)
  # We need to strip ANSI codes to get the actual display width
  local left_content="${user_host_plain} ${current_path_plain}${git_branch_plain} ${git_indicator_plain}"
  local left_len=${#left_content}

  # Calculate spacing needed
  local spacing=$((term_width - left_len - datetime_len - 1))

  # If there's enough space, add padding; otherwise, omit the time
  if [[ $spacing -gt 0 ]]; then
    printf "%${spacing}s" ""
    echo "%{$TIME_COLOR%}${datetime_str}%{$reset_color%}"
  fi
}

# =======================================================================
# PROMPT DEFINITION
# =======================================================================
# Configure vcs_info to just give us the branch name with the icon.
zstyle ':vcs_info:git:*' formats ' %{$GIT_PROMPT_INFO%} %b%{$reset_color%}'

build_prompt() {
  vcs_info
  local git_indicator=$(get_git_status_indicator)

  # Build the components with colors
  local user_host="%{$MACHINE_NAME_COLOR%}%n@%m%{$reset_color%}"
  local current_path="%{$PROMPT_SUCCESS_COLOR%}%~%{$reset_color%}"

  # Build plain text versions for length calculation
  # These use prompt expansion to get the actual text without color codes
  local user_host_plain="${(%):-%n@%m}"
  local current_path_plain="${(%):-%~}"
  local git_branch_plain="${vcs_info_msg_0_//\%\{*\%\}/}"  # Strip color codes
  local git_indicator_plain="${git_indicator//\%\{*\%\}/}"  # Strip color codes

  # Method 1: Using print -P to create a single-line prompt with right-aligned time
  # This method uses Zsh's built-in right-prompt functionality on the first line
  local datetime_str="%{$TIME_COLOR%}$(date '+%d-%b-%Y %H:%M %Z')%{$reset_color%}"

  # Create the first line with manual right alignment
  # The %(l.t.f) construct doesn't work well with dynamic content, so we'll use a different approach

  # Build the first line components
  local first_line_left="${user_host} ${current_path}${vcs_info_msg_0_} ${git_indicator}"

  # Method 2 (Recommended): Use a helper function to print the first line with right-aligned time
  # This approach manually calculates spacing
  PROMPT='$(print_first_line)'$'\n'"%{$PROMPT_PROMPT%} ─ ᐅ %{$reset_color%} "

  # Clear RPROMPT since we're handling right-alignment manually
  RPROMPT=""
}

# Helper function to print the first line with right-aligned time
print_first_line() {
  # Re-evaluate these in the subshell for current state
  vcs_info
  local git_indicator=$(get_git_status_indicator)

  local user_host="%{$MACHINE_NAME_COLOR%}%n@%m%{$reset_color%}"
  local current_path="%{$PROMPT_SUCCESS_COLOR%}%~%{$reset_color%}"
  local datetime_str="$(date '+%d-%b-%Y %H:%M %Z')"

  # Build the left side
  local left_content="${user_host} ${current_path}${vcs_info_msg_0_} ${git_indicator}"

  # Print the left content
  print -n -P "${left_content}"

  # Calculate the display width of the left content (without ANSI codes)
  # We need to use prompt expansion and then strip ANSI sequences
  local left_expanded="$(print -P "${left_content}" | sed $'s/\033\[[0-9;]*m//g')"
  local left_len=${#left_expanded}

  # Calculate spacing
  local datetime_len=${#datetime_str}
  local term_width=${COLUMNS:-80}  # Default to 80 if COLUMNS is not set
  local spacing=$((term_width - left_len - datetime_len))

  # Print spacing and right-aligned time if there's room
  if [[ $spacing -gt 0 ]]; then
    printf "%${spacing}s" ""
    print -P "%{$TIME_COLOR%}${datetime_str}%{$reset_color%}"
  else
    # If no room, just print a newline
    echo
  fi
}

# Hook our functions into the Zsh lifecycle
add-zsh-hook precmd build_prompt
