# Editor function to open the current directory in preferred editor
# Tries cursor first, then vscode, then nvim

o() {
  if command -v cursor >/dev/null 2>&1; then
    cursor .
  elif command -v code >/dev/null 2>&1; then
    code .
  else
    nvim .
  fi
} 