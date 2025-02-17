#!/bin/bash

# 1. X-Code 설치
echo "Checking for Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
    echo "Xcode Command Line Tools are not installed. Installing now..."
    xcode-select --install
    echo "Xcode Command Line Tools installation initiated. Please complete the installation manually if prompted."
else
    echo "Xcode Command Line Tools are already installed."
fi

# 2. Homebrew 설치
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

# 3. Homebrew 환경 설정
echo "Configuring Homebrew..."

if [[ -d "/opt/homebrew" ]]; then
  HOMEBREW_PREFIX="/opt/homebrew"
elif [[ -d "/usr/local/bin" ]]; then
  HOMEBREW_PREFIX="/usr/local"
fi

echo 'eval "$('"$HOMEBREW_PREFIX"'/bin/brew shellenv)"' >> ~/.zprofile
eval "$("$HOMEBREW_PREFIX"/bin/brew shellenv)"
source ~/.zprofile
sudo chown -R $(whoami):admin /opt/homebrew
chmod -R 755 /opt/homebrew

# 4. Homebrew 업데이트
echo "Updating Homebrew..."
brew update && brew upgrade

# 5. mas (Mac App Store CLI) 설치
echo "Installing mas..."
brew install mas
hash -r

# 6. Brewfile 패키지 설치
echo "Installing Brewfile packages..."
BREWFILE_URL="https://raw.githubusercontent.com/hellmir/homebrew/main/Brewfile"
BREWFILE_PATH="/tmp/Brewfile"

if ! curl -fsSL "$BREWFILE_URL" -o "$BREWFILE_PATH"; then
    echo "Error occured: Failed to fetch Brewfile. Exiting."
    exit 1
fi

brew bundle --file="$BREWFILE_PATH"

# 7. 추가 작업
echo "Applying additional configurations..."

export RUNZSH=no
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
unset RUNZSH

mkdir -p ~/my-projects

defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 1

