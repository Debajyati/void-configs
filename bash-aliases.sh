# grep aliases
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
# Listing Aliases
alias etree='exa --tree --icons' # exa needs to be preinstalled
alias ls='ls --color=auto' 
alias la='ls -A'
alias laa='exa -a' # exa needs to be preinstalled
alias ll='ls -alF'
alias l='ls -CF'
# Directory navigation with fuzzy finder
alias cdf='cd $(find * -type d | fzf)' # fzf needs to be preinstalled
alias cdpf='cd $(fd -t d | fzf)' # fzf and fd both needs to be preinstalled
alias sad='cd ~ && cd $(fd -t d | fzf)' # fzf and fd both needs to be preinstalled
# file navigation with search & preview
alias pf="fzf --preview='bat --color=always {}' --bind shift-up:preview-page-up,shift-down:preview-page-down" # fzf & bat both needs to be preinstalled
alias plf="fzf --preview='less {}' --bind shift-up:preview-page-up,shift-down:preview-page-down" # fzf and less both needs to be preinstalled
# for convenience
alias cls='clear'
alias python='python3' # python3 needs to be preinstalled
alias nf='neofetch' # neofetch needs to be preinstalled
alias rm='trash' # trash-cli needs to be preinstalled
# git aliases
alias gla='git log --oneline --decorate --all --graph' # git needs to be preinstalled
