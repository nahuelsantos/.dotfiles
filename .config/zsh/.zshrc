# Zinit plugin manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Aliases
alias ls="colorls -1a"
alias ld="colorls -1a --dirs"
alias o='if command -v cursor >/dev/null 2>&1; then cursor .; elif command -v code >/dev/null 2>&1; then code .; else nvim .; fi' # Open finder in current directory
alias trcms="tye run --tags caac"
alias trweb="tye run --watch --debug --tags mobile"
alias vim='nvim'
alias c='clear'

# Plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab
zinit snippet OMZP::git

autoload -Uz compinit
compinit -D

# Completions config
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# Completions styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls $realpath'
zstyle ':fxf-tab:complete:__zoxide_z:*' fzf-preview 'ls $realpath'

# fzf shell integration
source <(fzf --zsh)

# zoxide
source <(zoxide init zsh)

###########
### NVM ###
###########
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
# Load NVM lazily by not immediately using a version.
# NVM will still pick up .nvmrc when changing directories or you can manually run 'nvm use'.
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use

###############################
### Add .NET Core SDK tools ###
###############################
export PATH="$PATH:/Users/nahuelsantos/.dotnet/tools"

#############
### Pyenv ###
#############
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv &>/dev/null; then
  eval "$(pyenv init -)" # Initializes pyenv shims and autocompletion. This command itself can contribute to startup time.
fi

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
  eval "$(oh-my-posh init zsh --config ~/.dotfiles/.config/ohmyposh/base.toml)"
  #eval "$(oh-my-posh init zsh --config https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/catppuccin_mocha.omp.json)"
fi
