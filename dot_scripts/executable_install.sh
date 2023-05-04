#!/bin/bash

# Define packages to install
PACKAGES=(
    zsh
    git
    curl
)

# Set color variables for echo messages
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if running on Ubuntu or Fedora
if [ -n "$(command -v apt-get)" ]; then
    # Ubuntu based system
    echo -e "${BLUE}Detected Ubuntu based system${NC}"
    sudo apt-get update
    sudo apt-get install -y "${PACKAGES[@]}"
    chsh -s $(which zsh)
elif [ -n "$(command -v dnf)" ]; then
    # Fedora based system
    echo -e "${BLUE}Detected Fedora based system${NC}"
    sudo dnf update
    sudo dnf install -y "${PACKAGES[@]}"
    sudo lchsh $USER
else
    echo -e "${BLUE}Unsupported distribution${NC}"
    exit 1
fi

# Install oh-my-zsh
echo -e "${BLUE}Installing oh-my-zsh${NC}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc --unattended

# Install zsh-autosuggestions
echo -e "${BLUE}Installing zsh-autosuggestions${NC}"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install zsh-syntax-highlighting
echo -e "${BLUE}Installing zsh-syntax-highlighting${NC}"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install starship
echo -e "${BLUE}Installing starship${NC}"
curl -fsSL https://starship.rs/install.sh | sh

echo -e "${BLUE}Installation complete${NC}"

