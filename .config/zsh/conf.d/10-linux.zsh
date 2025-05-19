# Linux specific configuration
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux specific tools

    # Linux specific prompt
    eval "$(oh-my-posh init zsh --config ~/.dotfiles/.config/ohmyposh/base.toml)"
fi 