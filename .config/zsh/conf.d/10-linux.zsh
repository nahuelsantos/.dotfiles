# Linux specific configuration
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Set consistent locale settings
    export LANG=en_GB.utf8
    export LANGUAGE=en_GB.utf8
    export LC_ALL=en_GB.utf8
    
    # Linux specific tools

    eval "$(oh-my-posh init zsh --config ~/.dotfiles/.config/ohmyposh/base.toml)"
fi 

