# Basic aliases
alias vim='nvim'
alias c='clear' 

# Editor and file management aliases
alias ls="eza --icons --group-directories-first -1"
alias ld="eza --icons --group-directories-first --only-dirs"
alias ll="eza --icons --group-directories-first --long"
alias la="eza --icons --group-directories-first -1 --all"
alias lt="eza --icons --group-directories-first --tree"
alias trcms="tye run --tags caac"
alias trweb="tye run --watch --debug --tags mobile"

# FZF History Search function moved to functions/fzf.zsh 