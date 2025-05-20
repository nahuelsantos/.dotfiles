# Zinit plugin manager - with compatibility checks
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Only try to install/load zinit if not already done
if [[ ! -f "${ZINIT_HOME}/zinit.zsh" ]]; then
    # Create directory and clone repo if needed
    if [[ ! -d $ZINIT_HOME ]]; then
        mkdir -p "$(dirname $ZINIT_HOME)"
        git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" 2>/dev/null || {
            echo "Warning: Failed to clone zinit repository"
            return 0
        }
    fi
fi

# Source zinit with error handling
if [[ -f "${ZINIT_HOME}/zinit.zsh" ]]; then
    source "${ZINIT_HOME}/zinit.zsh" || {
        echo "Warning: Failed to source zinit.zsh"
        return 0
    }
    
    # Only load plugins if zinit was properly sourced
    if (( $+functions[zinit] )); then
        # Load plugins
        zinit light zsh-users/zsh-autosuggestions
        zinit light zsh-users/zsh-syntax-highlighting
        zinit light zsh-users/zsh-completions
        zinit light Aloxaf/fzf-tab
        zinit snippet OMZP::git
        
        # Initialize completions
        autoload -Uz compinit
        compinit -D
    fi
else
    echo "Warning: zinit.zsh not found. Skipping plugin loading."
fi 