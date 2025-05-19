# Development tools configuration
# These will only be loaded if the respective tools are available

# NVM
if [[ -d "$HOME/.nvm" ]]; then
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use
fi

# Pyenv
if command -v pyenv &>/dev/null; then
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

# Ruby (chruby)
if [[ -f /opt/homebrew/opt/chruby/share/chruby/chruby.sh ]]; then
    source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
    source /opt/homebrew/opt/chruby/share/chruby/auto.sh
    # Use the latest Ruby version available
    chruby $(chruby | grep -v '^\*' | head -n1 | tr -d ' ') 2>/dev/null
fi

# Go
if [[ -d "$HOME/go" ]]; then
    export PATH=$PATH:~/go/bin
fi

# .NET SDK
if [[ -d "$HOME/.dotnet" ]]; then
    export PATH="$PATH:$HOME/.dotnet/tools"
fi 