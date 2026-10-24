#!/usr/bin/env bash
#
# install.sh — bootstrap and refresh this dotfiles repo on macOS, Linux or WSL.
# Symlinks are made with GNU Stow; everything machine-specific stays untracked.
#
#   ./install.sh                          interactive: pick platform + components
#   ./install.sh --all                    everything for the detected platform
#   ./install.sh --only base,shell,ssh    only those components
#   ./install.sh --os macos|linux|wsl     force the platform
#   ./install.sh --dry-run --all          print the plan, change nothing
#   ./install.sh --yes                    no prompt, default component set
#
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)}"
BACKUP_ROOT="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
DRY_RUN=0
ASSUME_YES=0
TARGET_OS=""
SELECTED=""

COMPONENTS=(base shell prompt cli fonts ghostty nvim tmux git ssh sshkeys macos)
DEFAULT_ON="base,shell,prompt,cli,fonts,ghostty,nvim,tmux,git,ssh,sshkeys"
HOSTS=(melee plunder dinky)

say()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
info() { printf '    %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m[fail]\033[0m %s\n' "$*" >&2; exit 1; }

has() { command -v "$1" >/dev/null 2>&1; }

run() {
  if (( DRY_RUN )); then
    printf '    [dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

usage() {
  sed -n '3,12p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
  cat <<'EOF'

Components (base is always implied — it installs stow and makes the links):
  base     XDG dirs, ~/.ssh permissions, GNU stow, the symlink pass
  shell    zsh (zinit and its plugins clone themselves on the first shell)
  prompt   oh-my-posh, themed by .config/ohmyposh/base.toml
  cli      eza fzf zoxide bat ripgrep fd jq gh fastfetch btop tree
  fonts    MesloLGS NF (brew cask on macOS, manual elsewhere)
  ghostty  Ghostty terminal (brew cask on macOS, package on Linux)
  nvim     Neovim; lazy.nvim bootstraps itself on first start
  tmux     tmux with the catppuccin config
  git      git, ~/.gitconfig, ~/.gitignore_global
  ssh      ~/.ssh/config with the melee/plunder/dinky aliases
  sshkeys  per-host ed25519 keys in ~/.ssh (never in this repo)
  macos    macOS defaults — OFF by default, because taste is personal
EOF
}

parse_args() {
  while (( $# )); do
    case "$1" in
      --os)      TARGET_OS="${2:?--os needs a value}"; shift 2 ;;
      --only)    SELECTED="${2:?--only needs a value}"; shift 2 ;;
      --all)     SELECTED="all"; shift ;;
      --yes|-y)  ASSUME_YES=1; shift ;;
      --dry-run) DRY_RUN=1; shift ;;
      -h|--help) usage; exit 0 ;;
      *)         die "unknown argument: $1 (try --help)" ;;
    esac
  done
  case "$TARGET_OS" in
    ""|macos|linux|wsl) ;;
    *) die "--os must be one of: macos, linux, wsl" ;;
  esac
}

detect_os() {
  if [[ "$(uname -s)" == "Darwin" ]]; then echo macos; return; fi
  if grep -qi microsoft /proc/version 2>/dev/null; then echo wsl; return; fi
  echo linux
}

component_desc() {
  case "$1" in
    base)    echo "XDG dirs, stow, symlinks" ;;
    shell)   echo "zsh + zinit" ;;
    prompt)  echo "oh-my-posh" ;;
    cli)     echo "eza fzf zoxide bat ripgrep fd jq gh fastfetch btop tree" ;;
    fonts)   echo "MesloLGS NF nerd font" ;;
    ghostty) echo "Ghostty terminal" ;;
    nvim)    echo "Neovim + lazy.nvim" ;;
    tmux)    echo "tmux + catppuccin" ;;
    git)     echo "git + ~/.gitconfig" ;;
    ssh)     echo "ssh config for melee/plunder/dinky" ;;
    sshkeys) echo "per-host ed25519 keys" ;;
    macos)   echo "macOS defaults (opt-in)" ;;
    *)       echo "" ;;
  esac
}

enabled() {
  local want="$1" c
  for c in ${SELECTED//,/ }; do
    [[ "$c" == "$want" ]] && return 0
  done
  return 1
}

select_components() {
  local pick i=0 tok out=""
  printf '\nComponents:\n'
  for tok in "${COMPONENTS[@]}"; do
    i=$(( i + 1 ))
    printf '  %2d) %-8s %s\n' "$i" "$tok" "$(component_desc "$tok")"
  done
  printf '\nNumbers (e.g. 1 2 6), "all", or ENTER for the default set.\n> '
  read -r pick || pick=""
  [[ -n "$pick" ]] || pick="$DEFAULT_ON"
  case "$pick" in
    all|ALL) SELECTED="$(IFS=,; echo "${COMPONENTS[*]}")"; return 0 ;;
  esac
  for tok in ${pick//,/ }; do
    if [[ "$tok" =~ ^[0-9]+$ ]]; then
      if (( tok < 1 || tok > ${#COMPONENTS[@]} )); then
        warn "no component number $tok"
        continue
      fi
      out+="${COMPONENTS[$(( tok - 1 ))]},"
    else
      out+="${tok},"
    fi
  done
  SELECTED="${out%,}"
  [[ -n "$SELECTED" ]] || die "nothing selected"
}

# --- package helpers ---------------------------------------------------------

pkg_install() {
  local pkgs=("$@")
  (( ${#pkgs[@]} )) || return 0
  case "$TARGET_OS" in
    macos)
      has brew || die "Homebrew is required: https://brew.sh"
      run brew install "${pkgs[@]}" || warn "brew could not install: ${pkgs[*]}"
      ;;
    linux|wsl)
      if has apt-get; then
        run sudo apt-get update -qq
        run sudo apt-get install -y "${pkgs[@]}" || warn "apt could not install: ${pkgs[*]}"
      elif has dnf; then
        run sudo dnf install -y "${pkgs[@]}" || warn "dnf could not install: ${pkgs[*]}"
      elif has pacman; then
        run sudo pacman -S --needed --noconfirm "${pkgs[@]}" || warn "pacman could not install: ${pkgs[*]}"
      else
        warn "no supported package manager — install manually: ${pkgs[*]}"
      fi
      ;;
  esac
}

cask_install() {
  (( $# )) || return 0
  if [[ "$TARGET_OS" != "macos" ]]; then
    info "casks are macOS-only, skipping: $*"
    return 0
  fi
  has brew || die "Homebrew is required: https://brew.sh"
  run brew install --cask "$@" || warn "brew cask could not install: $*"
}

# --- components --------------------------------------------------------------

install_base() {
  run mkdir -p "$HOME/.local/bin" "$HOME/.config" "$HOME/.cache" "$HOME/.ssh"
  run chmod 700 "$HOME/.ssh"
  chmod +x "$DOTFILES_DIR/cht.sh" 2>/dev/null || true
  pkg_install stow
}

install_shell() { pkg_install zsh; }

install_prompt() { pkg_install oh-my-posh; }

install_cli() {
  if [[ "$TARGET_OS" == "macos" ]]; then
    pkg_install eza fzf zoxide bat ripgrep fd jq gh fastfetch btop tree
    return 0
  fi
  if has apt-get; then
    pkg_install eza fzf zoxide bat ripgrep fd-find jq fastfetch btop tree
  else
    pkg_install eza fzf zoxide bat ripgrep fd jq fastfetch btop tree
  fi
  # Debian/Ubuntu ship fd as `fdfind` and bat as `batcat`; give the names the
  # aliases and fzf-tab expect, without shadowing a real binary.
  if has fdfind && ! has fd; then
    run ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  fi
  if has batcat && ! has bat; then
    run ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
  fi
}

install_fonts() {
  if [[ "$TARGET_OS" == "macos" ]]; then
    cask_install font-meslo-lg-nerd-font
    return 0
  fi
  warn "MesloLGS NF is not packaged here — install any Nerd Font manually:"
  info "  mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts"
  info "  curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"
  info "  unzip Meslo.zip && rm Meslo.zip && fc-cache -f"
}

install_ghostty() {
  case "$TARGET_OS" in
    macos) cask_install ghostty ;;
    wsl)   info "Ghostty is a GUI terminal: install it on Windows, not inside WSL." ;;
    *)     pkg_install ghostty ;;
  esac
}

install_nvim() { pkg_install neovim; }

install_tmux() { pkg_install tmux; }

install_git() { pkg_install git; }

install_ssh() {
  if [[ "$TARGET_OS" != "macos" ]]; then
    pkg_install openssh-client
  fi
  [[ -d "$HOME/.ssh" ]] || run mkdir -p "$HOME/.ssh"
  run chmod 700 "$HOME/.ssh"
}

install_sshkeys() {
  local host key
  [[ -d "$HOME/.ssh" ]] || { run mkdir -p "$HOME/.ssh"; run chmod 700 "$HOME/.ssh"; }
  for host in "${HOSTS[@]}"; do
    key="$HOME/.ssh/id_ed25519_${host}"
    if [[ -f "$key" ]]; then
      info "key already present: $key"
    else
      run ssh-keygen -q -t ed25519 -N '' -C "nahuel-${host}-$(hostname -s)" -f "$key"
    fi
  done
  if (( DRY_RUN )); then
    info "[dry-run] would print the three public keys and the ssh-copy-id lines"
    return 0
  fi
  info "authorise each key once, from this machine:"
  info "  ssh-copy-id -i ~/.ssh/id_ed25519_melee.pub   nahuelsantos@192.168.3.8"
  info "  ssh-copy-id -i ~/.ssh/id_ed25519_plunder.pub nahuelsantos@192.168.3.7"
  info "  ssh-copy-id -i ~/.ssh/id_ed25519_dinky.pub   nahuelsantos@192.168.3.11"
  info "then verify: ssh melee hostname; ssh plunder hostname; ssh dinky hostname"
}

install_macos() {
  if [[ "$TARGET_OS" != "macos" ]]; then
    info "not macOS, skipping defaults"
    return 0
  fi
  run defaults write NSGlobalDomain AppleShowAllFiles -bool true
  run defaults write NSGlobalDomain KeyRepeat -int 2
  run defaults write NSGlobalDomain InitialKeyRepeat -int 15
  run defaults write com.apple.finder AppleShowAllFiles -bool true
  run defaults write com.apple.finder ShowPathbar -bool true
  run defaults write com.apple.dock autohide -bool true
  info "restart Finder and Dock to apply: killall Finder Dock"
}

# --- stow --------------------------------------------------------------------

backup_target() {
  local rel="$1"
  local dst
  dst="$BACKUP_ROOT/$(dirname -- "$1")"
  run mkdir -p "$dst"
  run mv -- "$HOME/$rel" "$dst/"
  info "backed up ~/$rel -> $dst/"
}

extract_clashes() {
  # stow has used at least three wordings for the same collision across versions.
  sed -n \
    -e 's/.*existing target is not owned by stow: //p' \
    -e 's/.*existing target is neither a link nor a directory: //p' \
    -e 's/.*over existing target \([^ ]*\) since.*/\1/p' \
    | sed 's/[[:space:]]*$//' \
    | grep -v '^$' || true
}

do_stow() {
  if ! has stow; then
    if (( DRY_RUN )); then
      warn "stow is not installed yet — a real run installs it, then links:"
      info "  stow --verbose=1 --no-folding --target=\$HOME --restow ."
      return 0
    fi
    die "stow is not installed. Install it with 'brew install stow', or re-run: ./install.sh --only base"
  fi
  [[ -d "$DOTFILES_DIR/.git" ]] || warn "$DOTFILES_DIR is not a git clone"
  # stow would otherwise create ~/.ssh with default permissions
  if [[ ! -d "$HOME/.ssh" ]]; then
    run mkdir -p "$HOME/.ssh"
    run chmod 700 "$HOME/.ssh"
  fi
  cd "$DOTFILES_DIR"

  local out rel clash
  if (( DRY_RUN )); then
    out="$(stow --simulate --no-folding --target="$HOME" . 2>&1 || true)"
    while IFS= read -r rel; do
      [[ -n "$rel" ]] || continue
      warn "collision: ~/$rel exists and is not from this repo"
      info "[dry-run] would move it to $BACKUP_ROOT/"
    done < <(printf '%s\n' "$out" | extract_clashes)
    info "[dry-run] would run: stow --verbose=1 --no-folding --target=\$HOME --restow ."
    return 0
  fi

  # A real run aborts and reports every collision it found, so move those aside
  # and try again. Never pass --adopt: that overwrites the repo with $HOME's
  # copies, which is the opposite of what this repo is for.
  for _ in 1 2 3; do
    if out="$(stow --verbose=1 --no-folding --target="$HOME" --restow . 2>&1)"; then
      printf '%s\n' "$out"
      return 0
    fi
    printf '%s\n' "$out" >&2
    clash=0
    while IFS= read -r rel; do
      [[ -n "$rel" ]] || continue
      clash=1
      warn "collision: ~/$rel exists and is not from this repo"
      backup_target "$rel"
    done < <(printf '%s\n' "$out" | extract_clashes)
    (( clash )) || die "stow failed and no colliding path was identified (output above)"
  done
  die "stow still failing after 3 attempts"
}

# --- untracked, machine-local files -----------------------------------------

write_if_missing() {
  local path="$1" body="$2"
  if [[ -f "$path" ]]; then
    info "kept existing $path"
    return 0
  fi
  if (( DRY_RUN )); then
    info "[dry-run] would create $path"
    return 0
  fi
  printf '%s\n' "$body" > "$path"
  info "created $path"
}

post_configure() {
  write_if_missing "$HOME/.gitconfig.local" \
'# Machine-local git overrides (untracked, wins over ~/.gitconfig).
# [user]
#   email = you@employer.com
# [commit]
#   gpgsign = true
# [gpg]
#   format = ssh'

  write_if_missing "$HOME/.ssh/config.local" \
'# Machine-local ssh overrides (untracked). Included first by ~/.ssh/config.'

  if [[ "$TARGET_OS" == "macos" ]]; then
    if (( DRY_RUN )); then
      info "[dry-run] would add AddKeysToAgent/UseKeychain to ~/.ssh/config.local"
    elif ! grep -q UseKeychain "$HOME/.ssh/config.local" 2>/dev/null; then
      printf 'Host *\n    AddKeysToAgent yes\n    UseKeychain yes\n' >> "$HOME/.ssh/config.local"
      info "macOS keychain handling added to ~/.ssh/config.local"
    fi
  fi
}

# --- main --------------------------------------------------------------------

main() {
  parse_args "$@"
  [[ -n "$TARGET_OS" ]] || TARGET_OS="$(detect_os)"
  say "platform=$TARGET_OS  dotfiles=$DOTFILES_DIR  dry-run=$DRY_RUN"
  if [[ -z "$SELECTED" ]]; then
    if (( ASSUME_YES )); then
      SELECTED="$DEFAULT_ON"
    else
      select_components
    fi
  fi
  if [[ "$SELECTED" == "all" ]]; then
    SELECTED="$(IFS=,; echo "${COMPONENTS[*]}")"
  fi
  say "components: $SELECTED"

  install_base           # always: stow and the symlink pass depend on it
  if enabled shell;   then install_shell;   fi
  if enabled prompt;  then install_prompt;  fi
  if enabled cli;     then install_cli;     fi
  if enabled fonts;   then install_fonts;   fi
  if enabled ghostty; then install_ghostty; fi
  if enabled nvim;    then install_nvim;    fi
  if enabled tmux;    then install_tmux;    fi
  if enabled git;     then install_git;     fi
  if enabled ssh;     then install_ssh;     fi
  if enabled sshkeys; then install_sshkeys; fi
  if enabled macos;   then install_macos;   fi

  do_stow
  post_configure

  say "done"
  info "open a new terminal, or run: exec zsh"
  info "safe to re-run: ./install.sh --all   (idempotent)"
}

# Guarded so the functions can be sourced by tests without running the install.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
