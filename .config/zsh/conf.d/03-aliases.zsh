# Basic aliases
alias vim='nvim'
alias c='clear'

# Editor and file management aliases — fall back to plain ls when eza is absent
if command -v eza >/dev/null 2>&1; then
    alias ls="eza --icons --group-directories-first -1"
    alias ld="eza --icons --group-directories-first --only-dirs"
    alias ll="eza --icons --group-directories-first --long"
    alias la="eza --icons --group-directories-first -1 --all"
    alias lt="eza --icons --group-directories-first --tree"
else
    alias ll='ls -l'
    alias la='ls -la'
    alias lt='ls -R'
fi

# FZF history search lives in functions/fzf.zsh
# Machine-local aliases belong in conf.d/99-local.zsh, which is gitignored
