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
# PROMPT DEFINITION
# =======================================================================

# Configure vcs_info to just give us the branch name with the icon.
zstyle ':vcs_info:git:*' formats ' %{$GIT_PROMPT_INFO%} %b%{$reset_color%}'

build_prompt() {
  vcs_info
  local git_indicator=$(get_git_status_indicator)

  # Build the left side of the prompt
  local user_host="%{$MACHINE_NAME_COLOR%}%n@%m%{$reset_color%}"
  local current_path="%{$PROMPT_SUCCESS_COLOR%}%~%{$reset_color%}"

  # Assemble the final, two-line PROMPT string.
  PROMPT="${user_host} ${current_path}${vcs_info_msg_0_} ${git_indicator}"$'\n'"%{$PROMPT_PROMPT%} ─ ᐅ %{$reset_color%} "
  RPROMPT="%{$TIME_COLOR%}$(date '+%d-%b-%Y %H:%M %Z')%{$reset_color%}"
}

# Hook our functions into the Zsh lifecycle
add-zsh-hook precmd build_prompt
