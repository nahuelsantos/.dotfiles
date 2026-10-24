# Login shells only — PATH and EDITOR live in ~/.zshenv, because non-interactive
# shells never read this file.

# macOS ships a usable UTF-8 locale under this name. Linux distros set their own,
# so leave them alone rather than forcing a locale that may not exist.
if [[ "$(uname -s)" == "Darwin" ]]; then
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
fi
