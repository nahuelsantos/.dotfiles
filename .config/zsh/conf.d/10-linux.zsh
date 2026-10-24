# Linux and WSL specific configuration
# ($OSTYPE is linux-gnu* inside WSL as well, so this covers both.)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Homebrew on Linux or WSL, if it is installed
    if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
fi
