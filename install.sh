#!/usr/bin/env bash

set -euo pipefail

# Pretty header
echo -e "\n  ⊹　  +  　  *　·   . 　 　 ⊹ .　　 　 ˚  ✫
˚　 ✦ *     · ·     + 　  ✦ 　˚     º. *   + 
　✫ º .    ✫ ✵  　˚   ʰᵉˡˡᵒ    ✫  ⋆    . 　
 ✧ 　 *　　　　 ˚  *  　  ♡ 　  ˚ ✫ 　　    ⋆˚
　 ˚  　 ✹ 　 .  + 　 ⊹    .*  ✦  ·    ✧˚ "
echo -e "             📦 LET’S BOOTSTRAP! 🚀\n"

# Repo root (where this script lives)
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Close any open System Preferences panes
osascript -e 'tell application "System Preferences" to quit' >/dev/null 2>&1 || true

echo -e "\n\n🔐 Enter password"
sudo -v

# Keep sudo alive
while true; do sudo -n true; sleep 1000; kill -0 "$$" || exit; done 2>/dev/null &

# Detect Mac architecture / Homebrew prefix
ARCH="$(uname -m)"
if [[ "$ARCH" == "arm64" ]]; then
  echo "🔍 Detected Apple Silicon. Using /opt/homebrew."
  HOMEBREW_PREFIX="/opt/homebrew"
else
  echo "🔍 Detected Intel Mac. Using /usr/local."
  HOMEBREW_PREFIX="/usr/local"
fi

# Ensure basic tools exist
if ! command -v curl >/dev/null 2>&1; then
  echo "❌ curl not found. Please install Xcode Command Line Tools first."
  exit 1
fi

if ! command -v unzip >/dev/null 2>&1; then
  echo "❌ unzip not found. Please install Xcode Command Line Tools first."
  exit 1
fi

# Command Line Tools (idempotent-ish)
if ! xcode-select -p >/dev/null 2>&1; then
  echo -e "\n\n😒 Installing Xcode CLI tools… (a prompt may appear)"
  xcode-select --install || true
else
  echo -e "\n\n✅ Xcode CLI tools already installed"
fi

# Install Homebrew if missing
if ! command -v brew >/dev/null 2>&1; then
  echo -e "\n\n🍺 Installing Homebrew…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Load brew into PATH for this script session
  if [[ -x "$HOMEBREW_PREFIX/bin/brew" ]]; then
    eval "$("$HOMEBREW_PREFIX/bin/brew" shellenv)"
  fi
else
  # Ensure brew is available in PATH for this script
  if [[ -x "$HOMEBREW_PREFIX/bin/brew" ]]; then
    eval "$("$HOMEBREW_PREFIX/bin/brew" shellenv)"
  fi
fi

echo -e "\n\n🍺 Updating brew…"
brew update
brew upgrade || true

# Brew bundle
echo -e "\n\n📦 Installing Homebrew apps and CLI packages from brewfile…"
echo -e "\nThis will take some time..."
if [[ -f "$REPO_DIR/brew/Brewfile" ]]; then
  brew bundle --file "$REPO_DIR/brew/Brewfile"
elif [[ -f "$REPO_DIR/Brewfile" ]]; then
  brew bundle --file "$REPO_DIR/Brewfile"
else
  echo "⚠️ No Brewfile found in repo; skipping brew bundle"
fi

echo -e "\n\n=================================================="
echo "🚮 Cleaning up any old brews or casks…"
brew cleanup || true

# Permissions for yabai and skhd
echo -e "\n\n🔐 yabai and skhd need Accessibility and Screen Recording permissions."
echo "   Opening Accessibility settings — add yabai and skhd if not already listed."
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
echo "   Press Enter when done…"
read -r
echo "   Opening Screen Recording settings — add yabai if not already listed."
open "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture"
echo "   Press Enter when done…"
read -r

# GNU Stow
if ! command -v stow >/dev/null 2>&1; then
  echo -e "\n\n🔗 Installing GNU Stow…"
  brew install stow
fi

# Backup helper (for first-run conflicts)
backup_path="$HOME/.dotfiles_backup/$(date +%Y%m%d-%H%M%S)"
backup() {
  local target="$1"
  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$backup_path"
    echo "📦 Backing up: $target -> $backup_path/"
    mv "$target" "$backup_path/" 2>/dev/null || true
  fi
}

# NVM + Node
NODE_VERSION="20.11.1"
echo -e "\n\n💚 Installing NVM and setting Node version (${NODE_VERSION})…"
if [[ ! -d "$HOME/.nvm" ]]; then
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1090
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
# shellcheck disable=SC1090
[[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"

if command -v nvm >/dev/null 2>&1; then
  nvm install "$NODE_VERSION"
  nvm alias default "$NODE_VERSION"
else
  echo "⚠️ nvm not available in this shell; open a new terminal and run: nvm install ${NODE_VERSION}"
fi

# Spicetify
echo -e "\n\n🎵 Installing Spicetify…"
if [[ ! -d "$HOME/Library/Application Support/Spotify" ]]; then
  echo "   Spotify needs to be launched at least once before Spicetify can be installed."
  echo "   Opening Spotify now — log in, let it load, then quit it."
  open -a Spotify 2>/dev/null || echo "⚠️ Could not open Spotify — make sure it's installed first."
  echo "   Press Enter when done…"
  read -r
fi
brew install spicetify-cli || true
if command -v spicetify >/dev/null 2>&1; then
  spicetify backup || true
  spicetify apply || true
  spicetify enable-devtools || true
  echo "✅ Spicetify installed"
else
  echo "⚠️ Spicetify not found after install; skipping"
fi

# Vencord installer (downloads and moves app)
echo -e "\n\n💬 Installing Vencord installer for Discord…"
tmp_vencord="$HOME/Downloads/VencordInstaller.MacOs.zip"
vencord_dir="$HOME/Downloads/vencord"
rm -rf "$vencord_dir" || true
curl -fL https://github.com/Vencord/Installer/releases/latest/download/VencordInstaller.MacOs.zip -o "$tmp_vencord" || true
mkdir -p "$vencord_dir"
unzip -o "$tmp_vencord" -d "$vencord_dir" >/dev/null 2>&1 || true
if [[ -d "$vencord_dir/VencordInstaller.app" ]]; then
  sudo mv "$vencord_dir/VencordInstaller.app" /Applications/ || true
  echo "✅ Vencord installed"
else
  echo "⚠️ Could not find VencordInstaller.app after unzip"
fi
rm -f "$tmp_vencord" || true

# Fonts (CommitMono Nerd Font)
echo -e "\n\n🔤 Installing CommitMono Nerd Font…"
tmp_zip="$HOME/Downloads/CommitMono.zip"
tmp_dir="$HOME/Downloads/CommitMono"
rm -rf "$tmp_dir" || true
curl -fL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CommitMono.zip -o "$tmp_zip" || true
mkdir -p "$tmp_dir"
unzip -o "$tmp_zip" -d "$tmp_dir" >/dev/null 2>&1 || true
mkdir -p "$HOME/Library/Fonts"
find "$tmp_dir" -maxdepth 2 -name "*.otf" -exec mv {} "$HOME/Library/Fonts/" \; 2>/dev/null || true
rm -rf "$tmp_dir" "$tmp_zip" || true
echo "✅ CommitMono fonts installed"

# Fonts (Iosevka Comfy) — fonts live in the repo itself, no releases
echo -e "\n\n🔤 Installing Iosevka Comfy fonts…"
tmp_dir="$HOME/Downloads/iosevka-comfy-repo"
rm -rf "$tmp_dir" || true
git clone --depth 1 https://github.com/protesilaos/iosevka-comfy.git "$tmp_dir" || true
mkdir -p "$HOME/Library/Fonts"
font_count=$(find "$tmp_dir" -path "*/TTF/*.ttf" | wc -l | tr -d ' ')
if [[ "$font_count" -gt 0 ]]; then
  find "$tmp_dir" -path "*/TTF/*.ttf" -exec cp {} "$HOME/Library/Fonts/" \; 2>/dev/null || true
  echo "✅ Iosevka Comfy fonts installed (${font_count} files)"
else
  echo "⚠️ No Iosevka Comfy font files found; skipping"
fi
rm -rf "$tmp_dir" || true

# Oh My Zsh
echo -e "\n\n💻 Installing Oh My Zsh…"
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  # Unattended so it doesn't hijack your shell session mid-script
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true
else
  echo "✅ Oh My Zsh already installed"
fi

# Zsh plugins (via brew)
echo -e "\n\n✨ Installing zsh plugins…"
brew install zsh-syntax-highlighting zsh-autosuggestions || true

# Terminal tweaks (Apple Terminal, not iTerm2)
echo -e "\n\n⏰ Removing that “last login” message…"
touch "$HOME/.hushlogin"
echo "✅ Removed 'last login' message"

echo -e "\n\n🔧 Setting Terminal defaults…"
defaults write com.apple.terminal "Default Window Settings" -string "Basic" || true
defaults write com.apple.terminal "Startup Window Settings" -string "Basic" || true
/usr/libexec/PlistBuddy -c "Set :Window\ Settings:Basic:Font:Size 14" "$HOME/Library/Preferences/com.apple.terminal.plist" 2>/dev/null || true

echo -e "\n\n🔗 Symlinking dotfiles with stow…"
cd "$REPO_DIR"

# Don’t let repo .DS_Store ever break stow
find . -name ".DS_Store" -print -delete 2>/dev/null || true
grep -qxF ".DS_Store" .gitignore 2>/dev/null || echo ".DS_Store" >> .gitignore

# Ensure base dirs exist
mkdir -p "$HOME/.config" "$HOME/.config/yabai" "$HOME/.config/skhd" "$HOME/Library/Application Support" \
  "$HOME/Library/Application Support/iTerm2/ColorSchemes"

# Back up known conflict targets (safe first-run behaviour)
backup "$HOME/.zshrc"
backup "$HOME/.zsh_aliases"

backup "$HOME/.config/starship.toml"
backup "$HOME/.config/sketchybar"
backup "$HOME/.config/borders"

backup "$HOME/.yabairc"
backup "$HOME/.skhdrc"
backup "$HOME/.config/skhd/skhdrc"

backup "$HOME/.config/halloy"
backup "$HOME/.config/nvim"
backup "$HOME/.tmux.conf"
backup "$HOME/.config/yazi"
backup "$HOME/.config/ghostty"
backup "$HOME/.config/doom"

backup "$HOME/.gitconfig"
backup "$HOME/.gitignore"

# Stow packages into HOME (must mirror $HOME paths)
stow -v -t "$HOME" \
  zsh \
  yabai \
  skhd \
  starship \
  sketchybar \
  halloy \
  mtmr \
  borders \
  git \
  nvim \
  tmux \
  yazi \
  ghostty \
  emacs \
  scripts

echo "✅ Dotfiles symlinked."

# iTerm2 colour scheme
if [[ -f "$REPO_DIR/iterm2/rose-pine.itermcolors" ]]; then
  cp "$REPO_DIR/iterm2/rose-pine.itermcolors" \
    "$HOME/Library/Application Support/iTerm2/ColorSchemes/rose-pine.itermcolors"
  echo "✅ iTerm2 Rose Pine colour scheme installed"
fi

# Reload configurations
echo -e "\n🔄 Reloading configurations…"

# Prefer brew services when available
if command -v brew >/dev/null 2>&1; then
  brew services start skhd >/dev/null 2>&1 || brew services restart skhd >/dev/null 2>&1 || true
  brew services start yabai >/dev/null 2>&1 || brew services restart yabai >/dev/null 2>&1 || true
fi

# Signal reloads / restarts as fallback
command -v skhd >/dev/null 2>&1 && brew services restart skhd >/dev/null 2>&1 && echo "✅ skhd restarted" || true
command -v yabai >/dev/null 2>&1 && yabai --restart-service >/dev/null 2>&1 && echo "✅ yabai service restarted" || true
command -v sketchybar >/dev/null 2>&1 && sketchybar --reload >/dev/null 2>&1 && echo "✅ SketchyBar reloaded" || true

echo -e "\n✅ Skhd, Sketchybar and Yabai setup complete"

# Git configuration (prefer stowed files)
echo -e "\n📂 Setting up Git configuration…"
if [[ -f "$HOME/.gitconfig" ]]; then
  echo "✅ .gitconfig present"
fi

if [[ -f "$HOME/.gitignore" ]]; then
  git config --global core.excludesfile "$HOME/.gitignore" || true
  echo "✅ Git global ignore set"
else
  echo "⚠️ No ~/.gitignore found; skipping excludesfile"
fi

# macOS preferences (your existing tweaks)
echo -e "\n\n🍎 Configuring MacOS system preferences…"
echo "=================================================="

# Trackpad
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true || true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1 || true
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true || true
echo "✅ Trackpad settings customized"

# Keyboard
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false || true
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false || true
defaults write -g NSAutomaticEmojiSubstitutionEnabled -bool false || true
echo "✅ Keyboard settings customized"

# Finder
defaults write com.apple.finder AppleShowAllFiles YES || true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv" || true
defaults write com.apple.finder _FXSortFoldersFirst -bool true || true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true || true
chflags nohidden "$HOME/Library" || true
defaults write com.apple.finder ShowPathbar -bool true || true
defaults write com.apple.finder ShowStatusBar -bool true || true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true || true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf" || true
echo "✅ Finder settings customized"

# Dock
defaults write com.apple.dock orientation -string right || true
defaults write com.apple.dock mineffect -string scale || true
defaults write com.apple.dock tilesize -integer 33 || true
defaults write com.apple.dock autohide-time-modifier -float 0.5 || true
defaults write com.apple.dock autohide-delay -float 0 || true

# Desktop
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true || true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true || true
echo "✅ Desktop settings customized"

echo "🔄 Restarting Finder and Dock…"
killall Finder >/dev/null 2>&1 || true
killall Dock >/dev/null 2>&1 || true

echo -e "\n\n👩‍💻 Setup complete!"
echo "✨💋🌈🍰🌻🌟💫🌱🐱🍿🍓"
echo -e "\n\n"

# Reload shell config
echo "🔄 Reloading shell…"
if [[ -f "$HOME/.zshrc" ]]; then
  # shellcheck disable=SC1090
  source "$HOME/.zshrc" || true
fi

echo -e "\n\n✅ Done.\n"
