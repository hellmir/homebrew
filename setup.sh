#!/bin/bash

# 1. Homebrew 설치
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Homebrew 환경 설정
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# 3. 패키지 설치
curl -fsSL https://raw.githubusercontent.com/hellmir/homebrew/main/Brewfile | brew bundle --file=/dev/stdin

# 4. 추가 작업
echo "Setting up additional configurations..."
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
mkdir -p ~/my-projects

defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 1

