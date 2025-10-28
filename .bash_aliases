alias diff='diff color=always'
alias svim='sudo -E nvim'
alias pd=pushd
alias vim=nvim

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias 'ls=ls --color=auto --group-directories-first '
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias igrep='grep -i --color=auto'
fi

# some more ls aliases
alias 'll=ls -alF --group-directories-first '
alias 'la=ls -lah --group-directories-first '
alias 'l=ls -CF --group-directories-first '

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
