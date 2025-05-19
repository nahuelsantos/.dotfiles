# Completions styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls $realpath'
zstyle ':fxf-tab:complete:__zoxide_z:*' fzf-preview 'ls $realpath'

# FZF integration - use more compatible approach
if command -v fzf &>/dev/null; then
    # Check for known fzf.zsh locations
    if [[ -f /usr/share/fzf/shell/key-bindings.zsh ]]; then
        source /usr/share/fzf/shell/key-bindings.zsh
    elif [[ -f ~/.fzf.zsh ]]; then
        source ~/.fzf.zsh
    elif [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
        source /usr/share/doc/fzf/examples/key-bindings.zsh
    fi
fi

# Zoxide integration
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi
