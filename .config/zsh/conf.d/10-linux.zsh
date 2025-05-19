# Linux specific configuration
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux specific tools

    # Linux specific prompt - only use oh-my-posh if available
    if command -v oh-my-posh &>/dev/null; then
        # Check oh-my-posh version to determine correct init method
        if oh-my-posh --version 2>/dev/null | grep -q "7"; then
            # Version 7+ uses oh-my-posh init zsh
            eval "$(oh-my-posh init zsh --config ~/.dotfiles/.config/ohmyposh/base.toml)"
        else
            # Fall back to a basic prompt if oh-my-posh doesn't support the new syntax
            PS1='%n@%m:%~$ '
        fi
    else
        # Basic prompt if oh-my-posh isn't installed
        PS1='%n@%m:%~$ '
    fi
fi 