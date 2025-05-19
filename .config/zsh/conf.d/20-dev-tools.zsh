# Development tools configuration
# These will only be loaded if the respective tools are available

# NVM
export NVM_DIR="$HOME/.nvm"
if [[ -d "$NVM_DIR" ]]; then
  # This loads nvm
  source "$NVM_DIR/nvm.sh"
  # This loads nvm bash_completion
  source "$NVM_DIR/bash_completion"
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