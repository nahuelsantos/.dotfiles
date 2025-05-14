# dotfiles
This repository contains the dotfiles I'm currently using in my development setup.

## Requirements

Make sure that you have the following installed in your system

### Git

```zsh
brew install git
```

### GNU Stow

I am currently using [GNU Stow](https://www.gnu.org/software/stow/) for an easy handling of all my configuration. 

```zsh
brew install stow
```

## Installation

For using stow just clone this repo in your $HOME foler and run stow .

```zsh
$ git clone https://github.com/nahuelsantos/.dotfiles.git
$ cd .dotfiles
$ stow .
```

## Troubleshooting

For ignoring files to be symlinked you can use the .stow-local-ignore file

If you have a conflict between files in your $HOME/.config directory and the .dotfiles/.config you can solve it with the ```--adopt``` flag. ```NOTE:``` The files inside the .dotfiles directory will be overwritten with the conflicting ones.

```zsh
stow --adopt . 
```
https://www.youtube.com/watch?v=y6XCebnB9gs
