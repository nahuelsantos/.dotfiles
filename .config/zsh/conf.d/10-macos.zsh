# macOS specific configuration
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Homebrew initialization
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    # macOS specific prompt
    if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
        eval "$(oh-my-posh init zsh --config ~/.dotfiles/.config/ohmyposh/base.toml)"
    fi
fi 