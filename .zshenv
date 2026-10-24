# Read by every zsh — interactive or not — so keep it cheap and side-effect free.

# XDG Base Directory Specification
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"

# Keep zsh's own files under $XDG_CONFIG_HOME/zsh
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
[[ -d "$ZDOTDIR" ]] || mkdir -p "$ZDOTDIR"

# PATH and EDITOR live here, not in ~/.zprofile: macOS GUI terminals do not
# inherit a login shell's PATH, and non-interactive shells never read .zprofile
# (which is how ~/.local/bin went missing on Linux).
typeset -U path
path=(
    "$HOME/.local/bin"
    $path
)

export EDITOR=nvim
export VISUAL=nvim
