#!/bin/bash

# Define packages to install
PACKAGES=(
    git
    curl
)

# Set color variables for echo messages
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to ask for confirmation
ask_confirmation() {
    read -p "$1 (Y/n) " choice
    case "$choice" in
        y|Y|'') return 0 ;;
        n|N) return 1 ;;
        *) return 0 ;;
    esac
}

# Check if sudo rights are available
if sudo -v &> /dev/null; then
	echo "User has sudo privileges."
    SUDO_AVAILABLE=true
else
	echo "User lacks sudo privileges."
    SUDO_AVAILABLE=false
fi

# Function to install packages
install_packages() {
    if [ $# -eq 0 ]; then
        echo "No packages provided."
        return 1
    fi
    
    # Check if running on Ubuntu or Fedora
	if [ -n "$(command -v apt-get)" ]; then
		# Ubuntu based system
		echo -e "${BLUE}Detected Ubuntu based system${NC}"
		sudo apt-get update
		sudo apt-get install -y "$@"

	elif [ -n "$(command -v dnf)" ]; then
		# Fedora based system
		echo -e "${BLUE}Detected Fedora based system${NC}"
		sudo dnf update
		sudo dnf install -y "$@"

	else
		echo -e "${BLUE}Unsupported distribution${NC}"
		exit 1
	fi
}

install_packages "${PACKAGES[@]}"

if ask_confirmation "Do you want to install zsh?"; then

    install_packages zsh nnn
	
	# Set zsh
	chsh -s $(which zsh)
	
	# Install oh-my-zsh
	echo -e "${BLUE}Installing oh-my-zsh${NC}"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc --unattended

	# Install zsh-autosuggestions
	echo -e "${BLUE}Installing or updating zsh-autosuggestions${NC}"
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 2> /dev/null || git -C ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions pull

	# Install zsh-syntax-highlighting
	echo -e "${BLUE}Installing or updating zsh-syntax-highlighting${NC}"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 2> /dev/null || git -C ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting pull

	# Install starship
	echo -e "${BLUE}Installing starship${NC}"
	curl -fsSL https://starship.rs/install.sh | sh -s -- -y
fi


if ask_confirmation "Do you want to install dev tools?"; then
	# Install nvm
	echo -e "${BLUE}Installing nvm and NodeJS${NC}"
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
	# Load nvm
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

	nvm install --lts
	nvm install-latest-npm
	#npm i -g git-user-switch
	
	echo -e "${BLUE}Installing git su${NC}"
	GIT_SU_URL="https://github.com/matsuyoshi30/gitsu/releases/download/v1.1.0/gitsu_1.1.0_linux_x86_64.tar.gz"
	GIT_SU_DIR="$HOME/bin"
	wget -qO- "$GIT_SU_URL" | tar -xz -C "$GIT_SU_DIR" --wildcards 'git-su' && chmod +x "$GIT_SU_DIR/git-su"
	
	echo -e "${BLUE}Installing pip${NC}"
	install_packages python3-pip
	
	echo -e "${BLUE}Installing conda${NC}"
	install_packages conda
else
    echo -e "${BLUE}Skipping installation of dev tools.${NC}"
fi

echo -e "${BLUE}Installation complete${NC}"

