# Completions styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls $realpath'
zstyle ':fxf-tab:complete:__zoxide_z:*' fzf-preview 'ls $realpath'

if command -v fzf &>/dev/null; then
    source <(fzf --zsh)
fi

if command -v zoxide &>/dev/null; then
    source <(zoxide init zsh)
fi
