# Sophie's dotfiles

Based on the idea from https://www.atlassian.com/git/tutorials/dotfiles

## Installation

### From scratch

The principle for creating such a repository
```
git init --bare $HOME/.dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
echo "alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.bashrc
```

### On a new system

```
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
echo ".dotfiles" >> .gitignore
git clone --bare git@github.com:sophie-xhonneux/.dotfiles.git $HOME/.dotfiles
config checkout
config config --local status.showUntrackedFiles no
```

The alias `alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'` should be in the .bashrc or .zshrc
