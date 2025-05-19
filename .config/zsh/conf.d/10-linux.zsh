# Linux specific configuration
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux specific aliases
    alias ls="eza --icons --group-directories-first -1"
    alias ld="eza --icons --group-directories-first --only-dirs"
    alias ll="eza --icons --group-directories-first --long"
    alias la="eza --icons --group-directories-first -1 --all"
    alias lt="eza --icons --group-directories-first --tree"
    alias o='if command -v cursor >/dev/null 2>&1; then cursor .; elif command -v code >/dev/null 2>&1; then code .; else nvim .; fi'

    # Linux specific tools
    if command -v fzf &>/dev/null; then
        source <(fzf --zsh)
    fi

    if command -v zoxide &>/dev/null; then
        source <(zoxide init zsh)
    fi

    # Linux specific prompt
    eval "$(oh-my-posh init zsh --config ~/.dotfiles/.config/ohmyposh/base.toml)"
fi 