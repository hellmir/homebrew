#!/bin/bash

# 1. Homebrew 설치
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed"
fi

# 2. Homebrew 환경 설정
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
source ~/.zprofile
brew update

# 3. mas 설치
brew install mas

# 4. 패키지 설치
echo "Installing Brewfile packages..."

BREWFILE_URL="https://raw.githubusercontent.com/hellmir/homebrew/main/Brewfile"
BREWFILE_CONTENT=$(curl -fsSL "$BREWFILE_URL")

if [[ -z "$BREWFILE_CONTENT" ]]; then
    echo "Error: Failed to fetch Brewfile. Exiting."
    exit 1
fi

echo "$BREWFILE_CONTENT" | brew bundle --file=/dev/stdin

# 5. 추가 작업
echo "Setting up additional configurations..."

export RUNZSH=no
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
unset RUNZSH

mkdir -p ~/my-projects

defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 1

