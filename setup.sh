#!/bin/bash

# 0. sudo 비밀번호 1회 입력 후 스크립트가 끝날 때까지 60초마다 갱신 (기본 타임아웃 5분)
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# 1. Xcode Command Line Tools
#    CLT가 없으면 2단계의 Homebrew 설치 스크립트가 softwareupdate로 무인 설치한다.
#    (xcode-select --install 은 GUI 팝업을 띄우므로 호출하지 않는다)

# 2. Homebrew 설치 — NONINTERACTIVE=1: Enter 대기 생략, sudo는 0단계 캐시 사용
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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

# 7. 추가 작업 — oh-my-zsh는 --unattended (chsh·zsh 실행·.zshrc 덮어쓰기 확인 생략)
echo "Applying additional configurations..."

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

mkdir -p ~/my-projects

defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 1

