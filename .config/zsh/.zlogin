# Print system information
if command -v fastfetch >/dev/null 2>&1; then
    fastfetch
elif command -v neofetch >/dev/null 2>&1; then
    neofetch
fi

# Print todo list if it exists
if [[ -f "$HOME/.todo" ]]; then
    echo "\n📝 TODO List:"
    cat "$HOME/.todo"
fi
