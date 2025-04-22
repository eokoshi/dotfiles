# Set up guide for config on a new machine  
Linux or WSL

## System packages

### fd
replaces find, is much faster

1. Ensure that `~/.local/bin/fd` is in your `$PATH` with 
```sh
echo $PATH | grep ~/.local/bin
```

if it is not in there, 

```sh
export PATH="~/.local/bin:$PATH"
```

2. Install fd-find and map it to `fd`

```sh
sudo apt install fd-find
ln -s $(which fdfind) ~/.local/bin/fd
```

### ripgrep

1. Install ripgrep
```sh
sudo apt-get install ripgrep
```

Now it should be usable with `rg`

### nvim

- for x86 machines

```sh
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim/*
sudo tar -C /opt/nvim -xzf nvim-linux-x86_64.tar.gz --strip-components=1
rm nvim-linux-x86_64.tar.gz
```

- for ARM (aarch64) machines

```sh
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz
sudo rm -rf /opt/nvim/*
sudo tar -C /opt/nvim -xzf nvim-linux-arm64.tar.gz --strip-components=1
rm nvim-linux-arm64.tar.gz
```

> [!NOTE]
> nvim 11.0 only works on Ubuntu 20+

### Tmux

```sh
sudo apt install tmux
```

### lazygit

- for x86 machines

```sh
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
```

- for ARM machines

```sh
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_arm64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
```

### gh (github cli)

```sh
sudo apt install gh
gh auth login
```

for github authentication, you may have to go into settings on github.com and add your machines public key, or generate a new authentication token  
I prefer SSH, so add your public key to github.com

### uv

python project manager

```sh
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### direnv

```sh
sudo apt install direnv
```

### age

encryption tool

```sh
sudo apt install age
```

### chezmoi

config manager

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
```

## Chezmoi Config

the current chezmoi config is for nvim >11.0

```sh
chezmoi init git@github.com:eokoshi/dotfiles.git
chezmoi diff
```

if everything looks ok, then you can run

```sh
chezmoi apply -v
```

otherwise, you can use `chezmoi edit $FILE` or `chezmoi merge $FILE` to make changes before updating your system

