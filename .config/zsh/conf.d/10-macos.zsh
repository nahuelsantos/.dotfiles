# macOS specific configuration
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Homebrew: /opt/homebrew on Apple Silicon, /usr/local on Intel
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi
