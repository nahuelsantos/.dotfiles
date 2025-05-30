# .dotfiles
This repository contains the dotfiles I'm currently using in my development setup.

## Requirements

Make sure that you have the following installed in your system

### Oh my Posh

```zsh
# If you have brew
brew install jandedobbeleer/oh-my-posh/oh-my-posh

#or for linux
curl -s https://ohmyposh.dev/install.sh | bash -s
```

### Git

```zsh
brew install git
```

### GNU Stow

I am currently using [GNU Stow](https://www.gnu.org/software/stow/) for an easy handling of all my configuration. 

```zsh
brew install stow
```

### eza

```zsh
brew install eza
```

### fzf

```zsh
brew install fzf
```

### zoxide

```zsh
brew install zoxide
```

## Installation

For using stow just clone this repo in your $HOME foler and run stow .

```zsh
$ git clone https://github.com/nahuelsantos/.dotfiles.git
$ cd .dotfiles
$ stow .
```

## zsh configuration
We need to create a symbolic link for .zshenv in your home directory:
```zsh
ln -sf ~/.config/zsh/.zshenv ~/.zshenv
```

## Troubleshooting

For ignoring files to be symlinked you can use the .stow-local-ignore file

If you have a conflict between files in your $HOME/.config directory and the .dotfiles/.config you can solve it with the ```--adopt``` flag. ```NOTE:``` The files inside the .dotfiles directory will be overwritten with the conflicting ones.

```zsh
stow --adopt . 
```
https://www.youtube.com/watch?v=y6XCebnB9gs

## References
* [Catppuccin tmux](https://github.com/catppuccin/tmux)
* [Catppuccin nvim](https://github.com/catppuccin/nvim)
* [GNU Stow](https://www.gnu.org/software/stow/)