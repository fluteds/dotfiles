# Homebrew (Apple Silicon + fallback)
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="robbyrussell"
plugins=(git)
source "$ZSH/oh-my-zsh.sh"

# Zsh plugins (prefer Homebrew prefix so it works on both /opt/homebrew and /usr/local)
HOMEBREW_PREFIX="$(brew --prefix 2>/dev/null)"

if [ -n "$HOMEBREW_PREFIX" ]; then
  [ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
    source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

  [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
    source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Source all alias files (only if they exist)
alias_dir="$HOME/.zsh_aliases"
if [ -d "$alias_dir" ]; then
  for file in "$alias_dir"/*(.N); do
    source "$file"
  done
fi

claude() {
  print '⋆　      ⋏    ⪩⪨⋏　    ⟑    ⪩⪨⟑     ⋆'
  print '    　  ⚞ ᴖ  ᴗ  ᴖ ⚟   ミo̶̶̷̤  ｡ o̴̶̷̤ミ'
  print '      ♡ﾟ  づ🧋ど    ♡   づ🍵ど  *♡ﾟ'
  command claude "$@"
}


# Common aliases
alias python="python3"
alias pip="pip3"

# Editor
export EDITOR="code --wait"

# PATH additions (avoid duplicates)
path=(
  "$HOME/scripts"
  "$HOME/.local/bin"
  $path
)
typeset -U path PATH

# Base64 decode + copy to clipboard (macOS pbcopy, Linux xclip/wl-copy)
b64() {
  echo "$1" | base64 --decode | tee >(
    pbcopy 2>/dev/null || xclip -selection clipboard 2>/dev/null || wl-copy 2>/dev/null
  )
}

# Random Pokemon (only if installed)
command -v pokeget >/dev/null 2>&1 && pokeget random

# Starship (only if installed)
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# NVM (lazy-load so your shell starts faster)
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  command nvm "$@"
}
node() { nvm use --silent >/dev/null 2>&1; command node "$@"; }
npm()  { nvm use --silent >/dev/null 2>&1; command npm "$@"; }
npx()  { nvm use --silent >/dev/null 2>&1; command npx "$@"; }
