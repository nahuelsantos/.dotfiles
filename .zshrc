# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

alias l="colorls" # List files in current directory
alias ll="colorls -al" # List all files in long list format
alias ls="colorls"
alias o="open ." # Open finder in current directory
alias trcms="tye run --tags caac"
alias trweb="tye run --watch --debug --tags mobile"

###################
### OMZ Plugins ###
###################
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

###########
### NVM ###
###########
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

###############################
### Add .NET Core SDK tools ###
###############################
export PATH="$PATH:/Users/nahuelsantos/.dotnet/tools"

#############
### Pyenv ###
#############
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

##############
### chruby ###
##############
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
chruby ruby-2.7.5
export PATH=$PATH:~/go/bin

################
### Aily 1.0 ###
################
export ENVIRONMENT_NAME="local"
export REDSHIFT_SECRET="redshift-connection"
export POSTGRES_SECRET="postgres-connection"
export REDIS_SECRET="redis-connection" 
export COGNITO_SECRET="cognito-configuration"
export LOCALSTACK_URL="http://localhost:4566"
export AWS_DYNAMODB_USERPROFILE_TABLE="UserProfile" 

if [[ -z "$TMUX" ]]; then
#  source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
 # [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh)"
fi
