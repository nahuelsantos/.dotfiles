# Set up PATH
typeset -U path
path=(
    $HOME/.local/bin
    $path
)

# Set up language
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Set up editor
export EDITOR=nvim
export VISUAL=nvim 