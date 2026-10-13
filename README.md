# macOS 초기 환경설정

새 Mac에서 터미널 명령 한 줄로 개발 도구와 앱을 설치하는 저장소다.

| 파일 | 내용 |
|---|---|
| `setup.sh` | Xcode Command Line Tools · Homebrew · oh-my-zsh 설치와 기본 설정을 수행하는 스크립트 |
| `Brewfile` | Homebrew로 설치할 formula · cask · Mac App Store 앱 목록 |

## 설치

터미널을 열고 아래 명령을 실행한다.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/hellmir/homebrew/main/setup.sh)"
```

시작 직후 macOS 사용자 비밀번호를 한 번 묻는다. 그 뒤에는 입력 없이 끝까지 진행된다.

> **`curl … | bash` 형태로 실행하지 않는다.**
> 파이프로 넘기면 stdin이 터미널이 아니어서 Homebrew 설치 스크립트가 비대화 모드로 전환되고,
> `/opt/homebrew` 생성에 필요한 sudo 권한을 얻지 못해 중단된다.
> 위 명령은 스크립트 본문을 인자로 넘기므로 stdin이 터미널로 유지된다.

## 실행 전 준비

- 관리자(admin) 계정으로 로그인한 상태여야 한다. `sudo`가 필요하다.
- `Brewfile`의 `mas` 항목(Mac App Store 앱)을 설치하려면 **App Store 앱에서 Apple 계정에 먼저 로그인**해 둔다.
  - `mas`에는 로그인 명령이 없다. 로그인되어 있지 않으면 `mas`가 App Store 로그인 다이얼로그를 띄운다.
  - `mas install`은 그 Apple 계정으로 이미 받았거나 구매한 앱만 설치한다. 유료 앱 구매는 App Store에서 직접 한다.
  - `mas` 항목이 실패해도 `brew bundle`은 나머지 항목을 계속 설치하고, 마지막에 실패 개수를 출력한다.

## 스크립트가 하는 일

| 단계 | 내용 |
|---|---|
| 0 | `sudo -v`로 인증 1회. 스크립트가 끝날 때까지 60초마다 갱신해 이후 비밀번호를 다시 묻지 않는다 |
| 1 | Xcode Command Line Tools. 없으면 2단계의 Homebrew 설치 스크립트가 `softwareupdate`로 무인 설치한다 |
| 2 | Homebrew 설치 (`NONINTERACTIVE=1`, Enter 대기 없음) |
| 3 | `~/.zprofile`에 `brew shellenv` 등록, `/opt/homebrew` 소유권을 현재 사용자로 설정 |
| 4 | `brew update && brew upgrade` |
| 5 | `mas` 설치 |
| 6 | 이 저장소의 `Brewfile`을 내려받아 `brew bundle` 실행 |
| 7 | oh-my-zsh 설치(`--unattended`), `~/my-projects` 생성, 키 반복 설정(길게 누름 메뉴 끔, 반복 속도) |

## 설치 목록

### Homebrew formula

git, gh, zsh, zsh-completions, zsh-syntax-highlighting, pipenv, awscli, gitleaks

### Homebrew cask

karabiner-elements, alt-tab, iterm2, rectangle, maccy, raycast, google-chrome, slack, notion, sourcetree,
android-studio, discord, docker, postman, obs, cold-turkey-blocker, ridibooks, itsycal, iina, dbeaver-community,
cyberduck, showyedge, gureumkim, linearmouse, tabby, figma, session-manager-plugin, bluestacks, obsidian, claude, chatgpt

### Mac App Store (mas)

Xcode, Pixea, 한컴오피스 한글 viewer, RunCat, Microsoft Word, 알라딘 eBook

## 설치 후

- 터미널을 닫았다가 다시 연다. `~/.zprofile`(Homebrew 경로)과 `~/.zshrc`(oh-my-zsh)가 적용된다.
- `brew bundle` 마지막 요약에 실패 항목이 있으면 그 항목만 다시 설치한다.

```bash
brew install <formula>
brew install --cask <cask>
mas install <id>
```

## Brewfile 갱신

현재 Mac에 설치된 목록으로 `Brewfile`을 다시 만들고, `git diff`로 확인한 뒤 커밋한다.

```bash
brew bundle dump --file=Brewfile --force
```

## 알려진 동작

- Apple Silicon(`/opt/homebrew`) 기준이다. Intel Mac에서는 3단계의 `/opt/homebrew` 소유권 설정 줄이 오류를 출력하고 다음 단계로 넘어간다.
- Command Line Tools 무인 설치가 실패하면 Homebrew 설치 스크립트가 GUI 설치 창을 띄우고, 완료 후 키 입력을 기다린다.
- 스크립트를 두 번 실행하면 `~/.zprofile`에 `brew shellenv` 줄이 중복으로 추가된다.
- `Brewfile` 다운로드에 실패하면 그 시점에 종료한다. 그 외 단계는 실패해도 다음 단계로 넘어간다.
