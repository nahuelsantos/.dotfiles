# Set XDG Base Directory Specification paths
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"

# Set ZDOTDIR to the XDG-compliant location
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# Ensure the directory exists
if [[ ! -d "${ZDOTDIR}" ]]; then
    mkdir -p "${ZDOTDIR}"
fi 