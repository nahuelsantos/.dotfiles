# dotfiles
This repository is where I keep the dotfiles I'm currently using in my development setup.
The OS is macOS Sequoia and my editor of choice is Neovim.
My env is highly customized and adapted to my workflow, I am currently using [GNU Stow](https://www.gnu.org/software/stow/) for an easy handling of all my configuration. 

```zsh
For using stow just clone this repo in your $HOME foler and run stow .
git clone https://github.com/nahuelsantos/.dotfiles.git
cd .dotfiles
stow .
```

For ignoring files to be symlinked you can use the .stow-local-ignore file

If you have a conflict between files in your $HOME/.config directory and the .dotfiles/.config you can solve it with the ```--adopt``` flag. ```NOTE:``` The files inside the .dotfiles directory will be overwritten with the conflicting ones.

```zsh
stow --adopt . 
```
