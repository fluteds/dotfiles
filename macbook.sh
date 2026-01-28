# ———————————————————————————————————————————————————————————————————————————
#  One install script to rule them all
#  Most taken from https://github.com/skullface/dotfiles/blob/main/install.sh
# ———————————————————————————————————————————————————————————————————————————

echo -e "\\n  ⊹　  +  　  *　·   . 　 　 ⊹ .　　 　 ˚  ✫
˚　 ✦ *     · ·     + 　  ✦ 　˚     º. *   + 
　✫ º .    ✫ ✵  　˚   ʰᵉˡˡᵒ    ✫  ⋆    . 　
 ✧ 　 *　　　　 ˚  *  　  ♡ 　  ˚ ✫ 　　    ⋆˚
　 ˚  　 ✹ 　 .  + 　 ⊹    .*  ✦  ·    ✧˚ "
echo -e "             📦 LET’S BOOTSTRAP! 🚀\\n"

# Close any open System Preferences panes
osascript -e 'tell application "System Preferences" to quit'

echo -e "\\n\\n🔐 Enter password"
sudo -v

# Detect Mac architecture
ARCH=$(uname -m)
# Check if the machine is Apple Silicon (arm64) or Intel (x86_64)
if [[ "$ARCH" == "arm64" ]]; then
    echo "🔍 Detected Apple Silicon. Using /opt/homebrew."
    export PATH="/opt/homebrew/bin:$PATH"  # Set Homebrew path for Apple Silicon
else
    echo "🔍 Detected Intel Mac. Using /usr/local."
    export PATH="/usr/local/bin:$PATH"  # Set Homebrew path for Intel Mac
fi

# Keep alive: update existing `sudo` timestamp until `.macos` has finished
while true; do sudo -n true; sleep 300; kill -0 "$$" || exit; done 2>/dev/null &

# Command Line Tools
echo -e "\\n\\n😒 Installing Xcode CLI tools… this will take a while."
xcode-select --install

# Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
    echo -e "\n\n🍺 Installing Homebrew…"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi
brew update && brew upgrade

echo -e "\\n\\n📦 Installing Homebrew apps and CLI packages…"
brew bundle

echo -e "\\n\\n=================================================="
echo "🚮 Cleaning up any old brews or casks…"
brew cleanup

# NVM
echo -e "\\n\\n💚 Installing NVM and setting Node version…"
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install 20.11.1
nvm alias default 20.11.1

# Spicetify
echo -e "\\n\\n🎵 Installing Spicetify…"
brew install spicetify-cli
spicetify backup
spicetify apply 
spicetify enable-devtools
echo "✅ Spicetify installed"

# Vencord
echo -e "\\n\\n💬 Installing Vencord installer for Discord…"
curl -L https://github.com/Vencord/Installer/releases/latest/download/VencordInstaller.MacOs.zip -o ~/Downloads/VencordInstaller.MacOs.zip
unzip ~/Downloads/VencordInstaller.MacOs.zip
sudo mv ~/Downloads/vencord/VencordInstaller.app /Applications/
rm ~/Downloads/VencordInstaller.MacOs.zip
echo "✅ Vencord installed"

# Customize Terminal: download and install custom font
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CommitMono.zip
mv CommitMono.zip ~/Downloads/CommitMono.zip
unzip ~/Downloads/CommitMono.zip -d ~/Downloads/CommitMono
mv ~/Downloads/CommitMono/*.otf ~/Library/Fonts/
fc-cache -fv
rm -rf ~/Downloads/CommitMono
rm ~/Downloads/CommitMono.zip
echo "✅ Custom fonts downloaded and installed"

# Customize Terminal: ohmyzsh
echo -e "\\n\\n💻 Customizing command line with ohmyzsh…"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Set Terminal font size (change '14' to whatever size you prefer)
echo -e "\\n\\n🔧 Setting Terminal font size…"
osascript -e 'tell application "Terminal" to set font size of first window to 14'
echo "✅ Terminal font size set"

# Customize Terminal: ohmyzsh plugins
brew install zsh-syntax-highlighting zsh-autosuggestions
echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc

# Customize Terminal: Set default profile and font size
defaults write com.apple.terminal "Default Window Settings" -string "Basic"
defaults write com.apple.terminal "Startup Window Settings" -string "Basic"

# Set font size to 14
/usr/libexec/PlistBuddy -c "Set :Window\ Settings:Basic:Font:Size 14" ~/Library/Preferences/com.apple.terminal.plist

# Customize Terminal: remove last login msg
echo -e "\\n\\n⏰ Removing that “last login” message…"
touch ~/.hushlogin
echo "✅ Removed 'last login' message"

echo -e "\\n\\n🚀 Installing Spaceship theme…"
git clone https://github.com/denysdovhan/spaceship-prompt.git ~/.oh-my-zsh/custom/themes/spaceship-prompt
echo "✅ Downloaded Spaceship prompt"

# Starship: Download custom starship.toml configuration
echo -e "\\n\\n💫 Moving custom Starship configuration…"
cp starship.toml ~/.config/starship.toml
echo "✅ Starship configuration done"

# Spaceship: Install configuration
ln -s ~/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme ~/.oh-my-zsh/custom/themes/spaceship.zsh-theme
echo "✅ Symlink for Spaceship prompt set"

echo -e "\n\n📂 Copying configs to their proper locations…"
# Ensure directories exist
mkdir -p ~/.config
mkdir -p ~/.config/skhd ~/.config/yabai ~/Library/Application\ Support/MTMR ~/.config/sketchybar ~/.config/iterm2

# Backup existing configs before copying
[ -f ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.backup
[ -f ~/.config/skhd/skhdrc ] && cp ~/.config/skhd/skhdrc ~/.config/skhd/skhdrc.backup
[ -f ~/.config/yabai/yabairc ] && cp ~/.config/yabai/yabairc ~/.config/yabai/yabairc.backup

# Copy and set proper permissions
cp .zshrc ~/.zshrc && chmod 644 ~/.zshrc && echo "✅ .zshrc copied"
cp skhdrc ~/.config/skhd/skhdrc && chmod 644 ~/.config/skhd/skhdrc && echo "✅ skhdrc copied"
cp yabairc ~/.config/yabai/yabairc && chmod 755 ~/.config/yabai/yabairc && echo "✅ yabairc copied"
cp -r mtmr ~/Library/Application\ Support/MTMR && echo "✅ MTMR copied"
cp -r sketchybar ~/.config/sketchybar && echo "✅ sketchybar copied"
cp -r iterm2 ~/.config/iterm2 && echo "✅ iterm2 copied"
echo -e "✅ Configs successfully copied!"

# Reload configurations
echo -e "\\n🔄 Reloading configurations…"
pkill -USR1 skhd && echo "✅ skhd config reloaded"
yabai --restart-service && echo "✅ yabai service restarted"
sketchybar --reload && echo "✅ SketchyBar reloaded"
echo -e "\\n✅ Skhd, Sketchtbar and Yabai setup complete"

# Git Configuration
echo -e "\\n📂 Setting up Git configuration…"
cp git/.gitconfig ~/.gitconfig && chmod 644 ~/.gitconfig
cp git/.gitignore ~/.gitignore && chmod 644 ~/.gitignore

# Set global Git ignore file
git config --global core.excludesfile ~/.gitignore
echo -e "\\n✅ Git setup complete"

# MacOS Settings
# Trackpad, Keyboard, Finder, Desktop and Dock settings
echo -e "\\n\\n🍎 Configuring MacOS system preferences…"
echo "=================================================="

# Trackpad: Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# Trackpad: Enable "natural" scroll
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true
echo "✅ Trackpad settings customized"

# Keyboard: Disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
# Keyboard: Disable double space for period
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
# Keyboard: Disable smart emojis eg <3 to ❤️
defaults write -g NSAutomaticEmojiSubstitutionEnabled -bool false
echo "✅ Keyboard settings customized"

# Behavior: Always show scrollbars
# defaults write NSGlobalDomain AppleShowScrollBars -string "Auto"
echo "✅ Behavior settings customized"

# Finder: Always show hidden files
defaults write com.apple.finder AppleShowAllFiles YES
# Finder: Use list view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Finder: Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# Finder: Expand save dialog by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
# Finder: Show the ~/Library folder in Finder window
chflags nohidden ~/Library
# Finder: Show Path bar in Finder window
defaults write com.apple.finder ShowPathbar -bool true
# Finder: Show Status bar in Finder window
defaults write com.apple.finder ShowStatusBar -bool true
# Finder: Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Finder: When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
echo "✅ Finder settings customized"

# Dock: move to right of screen
defaults write com.apple.dock orientation -string right
# Dock: use "scale" app minimization effect
defaults write com.apple.dock mineffect -string scale
# Dock: make icons smaller
defaults write com.apple.dock tilesize -integer 33
# Dock: halve the show/hide animation time 
defaults write com.apple.dock autohide-time-modifier -float 0.5
# Dock: remove delay to show/hide
defaults write com.apple.dock autohide-delay -float 0

# Dock: Show only active applications
#defaults write com.apple.dock static-only -bool true
#echo "✅ Dock settings customized"

# Desktop: Show removable media CDs, DVDs etc
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
# Desktop: Show external drives, USBs etc
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
echo "✅ Desktop settings customized"

echo "🔄 Now restarting Finder and Dock…"
sudo killall Finder && killall Dock

echo -e "\\n\\n👩‍💻 Setup complete!"
echo "✨💋🌈🍰🌻🌟💫🌱🐱🍿🍓"
echo -e "\\n\\n"

echo "🔄 Restarting Terminal..."
source ~/.zshrc
echo -e "\\n\\n"