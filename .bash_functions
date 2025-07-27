git_prompt_info() {
    # Check if we're in a Git repo
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        # Get branch name
        local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        
        # Get commit status
        local status=""
        if [[ -n $(git status --porcelain) ]]; then
            status="*"
        fi
        
        # Get ahead/behind info
        local ahead=$(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null | awk '{print $1}')
        local behind=$(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null | awk '{print $2}')
        local sync=""
        if [[ $ahead -gt 0 ]]; then sync="↑$ahead"; fi
        if [[ $behind -gt 0 ]]; then sync="↓$behind"; fi
        
        # Output branch name, sync info, and dirty state with no extra spaces
        echo "(${branch}${sync}${status})"
    fi
}

