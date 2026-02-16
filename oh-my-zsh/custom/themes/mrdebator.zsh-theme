# mrdebator.zsh-theme - A theme for ZSH
#
# Author: Ansh (mrdebator)
# URL: https://anshc.me/

# --- Enable Zsh Features ---
autoload -Uz vcs_info
autoload -U add-zsh-hook
setopt prompt_subst

# --- Color Definitions ---
ROOT_ICON_COLOR=$FG[111]
MACHINE_NAME_COLOR=$FG[208]
PROMPT_SUCCESS_COLOR=$FG[103]
PROMPT_PROMPT=$FG[208]
GIT_DIRTY_COLOR=$FG[124]
GIT_CLEAN_COLOR=$FG[148]
GIT_PROMPT_INFO=$FG[148]
GIT_LOADING_COLOR=$FG[244]

# =======================================================================
# GITSTATUS DAEMON INITIALIZATION
# =======================================================================
# Source the plugin. If it fails (not installed), the prompt will gracefully
# degrade and simply not show git info, rather than crashing the terminal.
if [[ -f "$ZSH_CUSTOM/plugins/gitstatus/gitstatus.plugin.zsh" ]]; then
    source "$ZSH_CUSTOM/plugins/gitstatus/gitstatus.plugin.zsh"

    # Start the daemon. We name the instance 'PROMPT'.
    # The -s -1 -u -1 -c -1 -d -1 flags tell the daemon to compute everything
    # (staged, unstaged, conflicted, untracked) without limits.
    gitstatus_start -s -1 -u -1 -c -1 -d -1 'PROMPT'
fi

# =======================================================================
# PROMPT DEFINITION
# =======================================================================

build_prompt() {
    local git_info=""

    # Query the daemon. If it succeeds, it populates VCS_STATUS_* variables.
    if gitstatus_query 'PROMPT'; then

        # Check if we are actually inside a Git repository
        if [[ "$VCS_STATUS_RESULT" == "ok-sync" || "$VCS_STATUS_RESULT" == "ok-async" ]]; then

            # Get branch name, fallback to short commit hash if detached
            local branch="${VCS_STATUS_LOCAL_BRANCH}"
            if [[ -z "$branch" ]]; then
                branch="${VCS_STATUS_COMMIT:0:8}"
            fi

            local indicator=""

            # ok-async means the repo is so big it's still calculating in the background.
            # We show a loading indicator instead of lagging the terminal.
            if [[ "$VCS_STATUS_RESULT" == "ok-async" ]]; then
                indicator="%{$GIT_LOADING_COLOR%}...%{$reset_color%}"
            else
                # The core logic: Unstaged > Staged > Ahead > Clean
                if (( VCS_STATUS_NUM_UNSTAGED > 0 || VCS_STATUS_NUM_UNTRACKED > 0 || VCS_STATUS_NUM_CONFLICTED > 0 )); then
                    indicator="%{$GIT_DIRTY_COLOR%}*%{$reset_color%}"
                elif (( VCS_STATUS_NUM_STAGED > 0 )); then
                    indicator="%{$GIT_DIRTY_COLOR%}+%{$reset_color%}"
                elif (( VCS_STATUS_COMMITS_AHEAD > 0 )); then
                    indicator="%{$GIT_DIRTY_COLOR%}↑%{$reset_color%}"
                else
                    indicator="%{$GIT_CLEAN_COLOR%}✔%{$reset_color%}"
                fi
            fi

            # Assemble the Git portion of the prompt
            git_info=" %{$GIT_PROMPT_INFO%} ${branch}%{$reset_color%} ${indicator}"

        fi
    fi

    # Build prompt components with colors
    local user_host="%{$MACHINE_NAME_COLOR%}%n@%m%{$reset_color%}"
    local current_path="%{$PROMPT_SUCCESS_COLOR%}%~%{$reset_color%}"

    # Assemble the two-line prompt
    local first_line="${user_host} ${current_path}${git_info}"
    local second_line="%{$PROMPT_PROMPT%} ─ ᐅ %{$reset_color%} "

    PROMPT="${first_line}"$'\n'"${second_line}"
    RPROMPT=""
}

add-zsh-hook precmd build_prompt

