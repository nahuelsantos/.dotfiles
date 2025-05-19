# Print system information
if [[ -x "$(command -v neofetch)" ]]; then
    neofetch
fi

# Print todo list if it exists
if [[ -f "$HOME/.todo" ]]; then
    echo "\n📝 TODO List:"
    cat "$HOME/.todo"
fi 