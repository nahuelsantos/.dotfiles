# .dotfiles

One clone, one command, same environment. Links are made with **GNU Stow**; anything
machine-specific is written to `$HOME` as an untracked file, never into this repo.

## Quick start

```zsh
git clone https://github.com/nahuelsantos/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ./install.sh
```

`install.sh` detects the platform, asks which components you want, installs what is
missing, then stows the config into `$HOME`. It is idempotent — run it again after a
`git pull` to pick up changes.

## Components

| flag | what it does |
|---|---|
| `base` | XDG dirs, `~/.ssh` permissions, GNU Stow, the symlink pass (always implied) |
| `shell` | zsh; zinit and its plugins clone themselves on the first shell |
| `prompt` | oh-my-posh, themed by `.config/ohmyposh/base.toml` |
| `cli` | eza fzf zoxide bat ripgrep fd jq gh fastfetch btop tree |
| `fonts` | MesloLGS NF (brew cask on macOS) |
| `ghostty` | Ghostty terminal |
| `nvim` | Neovim; lazy.nvim bootstraps itself on first start |
| `tmux` | tmux with the catppuccin config |
| `git` | git, `~/.gitconfig`, `~/.gitignore_global` |
| `ssh` | `~/.ssh/config` with the melee / plunder / dinky aliases |
| `sshkeys` | per-host ed25519 keys in `~/.ssh` (private keys never enter this repo) |
| `macos` | macOS defaults — **off** by default, because taste is personal |

```zsh
./install.sh                          # interactive
./install.sh --all                    # everything for this platform
./install.sh --only base,shell,git    # just these
./install.sh --os wsl                 # force the platform (macos|linux|wsl)
./install.sh --dry-run --all          # print the plan, change nothing
```

## What gets linked where

`./install.sh` runs `stow --no-folding --restow .` from the repo root, so each file
lands individually rather than the whole `.config` directory becoming a symlink —
that keeps other applications' `~/.config` writes out of this repo.

```
~/.zshenv                        -> .dotfiles/.zshenv
~/.zshenv sets ZDOTDIR=~/.config/zsh, PATH, EDITOR, XDG vars
~/.config/zsh/{.zshrc,...}       -> .dotfiles/.config/zsh/
~/.config/zsh/conf.d/*.zsh       sourced in alphabetical order
~/.config/ohmyposh/base.toml     -> .dotfiles/.config/ohmyposh/base.toml
~/.config/ghostty/config         -> .dotfiles/.config/ghostty/config
~/.config/nvim/                  -> .dotfiles/.config/nvim/
~/.config/tmux/tmux.conf         -> .dotfiles/.config/tmux/tmux.conf
~/.gitconfig                     -> .dotfiles/.gitconfig
~/.gitignore_global              -> .dotfiles/.gitignore_global
~/.ssh/config                    -> .dotfiles/.ssh/config
~/cht.sh                         -> .dotfiles/cht.sh
```

Never linked: `README.md`, `LICENSE`, `Brewfile*`, `install.sh`, `.git*` — see
`.stow-local-ignore`.

## Machine-local files (untracked, never in git)

| file | contents |
|---|---|
| `~/.config/zsh/conf.d/99-local.zsh` | employer env vars, project aliases, host-specific PATH. Start from `conf.d/99-local.zsh.example` |
| `~/.gitconfig.local` | work email, commit signing (included last, so it wins) |
| `~/.ssh/config.local` | `UseKeychain`, proxies, anything that must not be shared. Included first, so it wins |

## SSH to the homelab

`~/.ssh/config` is tracked and picks a **different key per host**:

```sshconfig
Host melee     HostName 192.168.3.8    User nahuelsantos  IdentityFile ~/.ssh/id_ed25519_melee
Host plunder   HostName 192.168.3.7    User nahuelsantos  IdentityFile ~/.ssh/id_ed25519_plunder
Host dinky     HostName 192.168.3.11   User nahuelsantos  IdentityFile ~/.ssh/id_ed25519_dinky
```

`./install.sh --only sshkeys` generates any missing key. Authorise each one once,
from this machine:

```zsh
ssh-copy-id -i ~/.ssh/id_ed25519_melee.pub   nahuelsantos@192.168.3.8
ssh-copy-id -i ~/.ssh/id_ed25519_plunder.pub nahuelsantos@192.168.3.7
ssh-copy-id -i ~/.ssh/id_ed25519_dinky.pub   nahuelsantos@192.168.3.11
ssh melee hostname; ssh plunder hostname; ssh dinky hostname   # expect the hostnames back
```

## Updating

```zsh
cd ~/.dotfiles && git pull && ./install.sh --all
```

`stow --restow` re-links whatever moved; files are symlinks, so content changes need
no re-run at all.

## Troubleshooting

**`stow` refuses because a file already exists there.** `install.sh` detects that,
moves the existing file to `~/.dotfiles-backup/<timestamp>/` and retries. Nothing is
lost; copy anything you still want into the repo or into `99-local.zsh`.

**Never use `stow --adopt`.** It overwrites the repo with whatever is already in
`$HOME` — the opposite of what this repo is for.

**zsh starts slow or plugins are missing.** The first shell clones zinit and its
plugins; check `git` is installed and reachable.

**Prompt does not appear.** `oh-my-posh` must be on `PATH` and
`~/.config/ohmyposh/base.toml` must exist. `conf.d/05-prompt.zsh` silently skips the
prompt when either is missing.
