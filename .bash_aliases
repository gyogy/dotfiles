alias diff='diff color=always'
alias vim=nvim
alias svim='sudo -E nvim'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias igrep='grep -i --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -lah'
alias l='ls -CF'

# python
alias py='python3'
alias ipy='ipython3'
alias pip='pip3'

# git
alias ga='git add'
alias gaa='git add -A'
alias gac='git add . && git commit -m'
alias gad='git add .'
alias gc='git commit'
alias gcm='git commit -m'
alias gd='git diff'
alias gs='git status'
alias gco='git checkout'
