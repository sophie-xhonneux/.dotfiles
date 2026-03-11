# Sophie's dotfiles

Based on the idea from https://www.atlassian.com/git/tutorials/dotfiles

## Installation of dotfiles

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

## Installation of tmux conf

Install TPM see here also

```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux
```
Press `Prefix + I` to install the plugins

## Install tools

Find out underlying kernel and Unix version with `uname -a`. Note `aarch64` is the same as `arm64` when looking for packages.

Go to `.local/bin`, get release binary with `wget`, then unpack the tar with `tar -xvf {file_name}`, delete the tar.
- [fzf](https://github.com/junegunn/fzf/releases) version 0.67
- [ripgrep](https://github.com/BurntSushi/ripgrep/releases) version 15.1
- [fd](https://github.com/sharkdp/fd/releases) version 10.4.2 musl for statically linked binary
- [zoxide](https://github.com/ajeetdsouza/zoxide) install via `curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh`

Go to `.local/share` to install neovim. Ensure `cmake` is available (telescope needs it)
- [neovim](https://github.com/neovim/neovim/releases/) version 11.4 from tar.gz
