#!/usr/bin/env bash

ARCH=$(uname -m)
set -ueo pipefail
export PATH="$PATH:~/.local/bin"

## apt packages
sudo apt-get -y --ignore-missing install ripgrep fd-find python3-venv npm direnv tmux lsd unzip
ln -s --force $(which fdfind) ~/.local/bin/fd

# tailscale
curl -fsSL https://tailscale.com/install.sh | sh

echo ""
read -p "Install GitHub CLI? [y/n]" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
	(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
		&& sudo mkdir -p -m 755 /etc/apt/keyrings \
			&& out=$(mktemp) && wget -nv -O"$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg \
			&& cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
		&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
		&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
		&& sudo apt update \
		&& sudo apt install gh -y
	gh auth login
fi

echo ""
read -p "Install chezmoi? [y/n]" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
	sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME"/.local/bin
	chezmoi init --apply eokoshi
fi


echo ""
read -p "Install uv? [y/n]" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
	curl -LsSf https://astral.sh/uv/install.sh | sh
	uv python install
fi


echo ""
read -p "Install zoxide and fzf? [y/n]" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
	if [ ! -d "~/.fzf" ]; then
		git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	fi
	DIR=$(pwd)
	cd ~/.fzf
	git pull
	./install
	ln -sf ./bin/fzf ~/.local/bin/fzf
	cd DIR

	curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
	fzf --version
	zoxide -V
fi



echo ""
read -p "Install nvim? [y/n]" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
	case $ARCH in
		x86_64)
			NVIM_SYS="nvim-linux-x86_64"
			;;
		aarch64|arm64)
			NVIM_SYS="nvim-linux-arm64"
			;;
		*)
			echo "Unsupported architecture: $ARCH"
			exit 1
			;;
	esac

	sudo rm -rf /opt/nvim
	sudo mkdir /opt/nvim
	curl -LO "https://github.com/neovim/neovim/releases/latest/download/${NVIM_SYS}.tar.gz"
	sudo tar -C /opt/nvim -xzf "${NVIM_SYS}.tar.gz" --strip-components=1
	rm -f "${NVIM_SYS}.tar.gz"
	ln -s --force /opt/nvim/bin/nvim ~/.local/bin/nvim
	nvim -v
fi

echo ""
read -p "Install yazi? [y/n]" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
	case $ARCH in
		x86_64)
			YAZI_SYS="yazi-x86_64-unknown-linux-gnu"
			;;
		aarch64|arm64)
			YAZI_SYS="yazi-aarch64-unknown-linux-gnu"
			;;
		*)
			echo "Unsupported architecture: $ARCH"
			exit 1
			;;
	esac

	sudo rm -rf /opt/yazi
	sudo mkdir /opt/yazi
	curl -LO "https://github.com/sxyazi/yazi/releases/latest/download/${YAZI_SYS}.zip"
	unzip "${YAZI_SYS}.zip"
	sudo mv "${YAZI_SYS}"/* /opt/yazi/
	rm -rf $YAZI_SYS
	rm -f "${YAZI_SYS}.zip"
	ln -s --force /opt/yazi/yazi ~/.local/bin/yazi
	ln -s --force /opt/yazi/ya ~/.local/bin/ya
	yazi -V
fi


echo ""
read -p "Install lazygit? [y/n]" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
	case $ARCH in
    x86_64)
        LAZYGIT_ARCH="linux_x86_64"
        ;;
    aarch64|arm64)
        LAZYGIT_ARCH="linux_arm64"
        ;;
    armv6l)
        LAZYGIT_ARCH="linux_armv6"
        ;;
    i386|i686)
        LAZYGIT_ARCH="linux_32-bit"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
	esac

	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_${LAZYGIT_ARCH}.tar.gz"
	tar xf lazygit.tar.gz lazygit
	sudo install lazygit -D -t /usr/local/bin/
	sudo rm -rf lazygit
	sudo rm lazygit.tar.gz
	lazygit --version
fi
echo ""
