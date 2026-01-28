export PATH="/opt/homebrew/bin:$PATH"

export ZSH="$HOME/.oh-my-zsh"
#ZSH_THEME="robbyrussell" # Use a ZSH theme

plugins=(git)

source $ZSH/oh-my-zsh.sh

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Find all my dotfiles~
typeset -U config_files
config_files=($HOME/Documents/Repos/keys/macos/aliases/*)

# And load ’em up
for file in ${${config_files}}
do
  source $file
done

alias python="python3"
alias pip="pip3"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Set code as default editor
export EDITOR="code --wait"

# Export scripts to path
export PATH="$HOME/scripts:$PATH"
export PATH="$PATH:/Users/autumn/.local/bin"

 # Decode base64
 b64() {
  echo "$1" | base64 --decode | tee >(pbcopy 2>/dev/null || xclip -sele
  ction clipboard 2>/dev/null || wl-copy 2>/dev/null)
}

# Get a random Pokemon
pokeget random

# Use Starship
eval "$(starship init zsh)"
