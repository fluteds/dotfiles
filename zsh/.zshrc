# Homebrew (Apple Silicon + fallback)
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="robbyrussell"
plugins=(git sudo colored-man-pages extract history-substring-search copypath)
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
  print ' '
  print '⋆　      ⋏    ⪩⪨⋏　    ⟑    ⪩⪨⟑     ⋆'
  print '    　  ⚞ ᴖ  ᴗ  ᴖ ⚟   ミo̶̶̷̤  ｡ o̴̶̷̤ミ'
  print '      ♡ﾟ  づ🧋ど    ♡   づ🍵ど  *♡ﾟ'
  print ' '
  command claude "$@"
}

# Editor (nvim for terminal, code for heavy GUI projects)
export EDITOR="nvim"
export VISUAL="nvim"

# PATH additions (avoid duplicates)
path=(
  "$HOME/scripts"
  "$HOME/.local/bin"
  "$HOME/go/bin"
  "$HOME/.cargo/bin"
  $path
)
typeset -U path PATH

# Base64 decode + copy to clipboard (macOS pbcopy, Linux xclip/wl-copy)
b64() {
  echo "$1" | base64 --decode | tee >(
    pbcopy 2>/dev/null || xclip -selection clipboard 2>/dev/null || wl-copy 2>/dev/null
  )
}

# Pokemon welcome screen
_pokemon_welcome() {
  local r='\033[0m' b='\033[1m' d='\033[2m'
  local y='\033[33m' c='\033[36m' m='\033[35m'
  local border='\033[2;35m'

  local flavors=(
    "A wild terminal appeared!"
    "What will you do?"
    "Gotta code 'em all!"
    "It's super effective!"
    "You used COFFEE. It's very effective!"
    "TRAINER wants to fight!"
    "Go! Open your editor!"
    "The foe used DISTRACTION. It had no effect."
    "The wild BUG approaches!"
    "You have a feeling of impending success."
    "This looks like a good place to push!"
  )

  local idx=$(( RANDOM % ${#flavors[@]} + 1 ))
  local flavor="${flavors[$idx]}"

  # Fetch Pokemon name + type from PokeAPI (gen 1–8, fallback to random)
  local poke_num=$(( RANDOM % 898 + 1 ))
  local poke_data poke_name='' poke_types=''
  poke_data=$(curl -sf --max-time 2 "https://pokeapi.co/api/v2/pokemon/$poke_num" 2>/dev/null)
  if [[ -n "$poke_data" ]]; then
    poke_name=$(printf '%s' "$poke_data" | jq -r '.name' 2>/dev/null)
    poke_types=$(printf '%s' "$poke_data" | jq -r '[.types[].type.name] | join(" / ")' 2>/dev/null)
  fi

  printf "\n"
  if (( RANDOM % 50 == 0 )); then
    printf "  ${m}${b}✨ Oh! A shiny Pokemon appeared!${r}\n"
    pokeget "${poke_name:-random}" --shiny --hide-name
  else
    pokeget "${poke_name:-random}" --hide-name
  fi
  printf "\n"

  # Type color based on primary type
  local type_color='\033[37m'
  local primary="${poke_types%% *}"
  case $primary in
    fire)     type_color='\033[38;5;202m' ;;
    water)    type_color='\033[34m'       ;;
    grass)    type_color='\033[32m'       ;;
    electric) type_color='\033[33m'       ;;
    psychic)  type_color='\033[35m'       ;;
    ice)      type_color='\033[96m'       ;;
    dragon)   type_color='\033[34m'       ;;
    dark)     type_color='\033[2;37m'     ;;
    fairy)    type_color='\033[95m'       ;;
    fighting) type_color='\033[31m'       ;;
    poison)   type_color='\033[35m'       ;;
    ground)   type_color='\033[33m'       ;;
    flying)   type_color='\033[96m'       ;;
    bug)      type_color='\033[92m'       ;;
    rock)     type_color='\033[33m'       ;;
    ghost)    type_color='\033[34m'       ;;
    steel)    type_color='\033[37m'       ;;
  esac

  # Battery HP bar with hearts
  local battery=$(pmset -g batt 2>/dev/null | grep -Eo '[0-9]+%' | head -1 | tr -d '%')
  local b_line='' bbar='' hp_color='\033[32m'
  if [[ -n "$battery" ]]; then
    local filled=$(( battery * 10 / 100 )) empty=$(( 10 - battery * 10 / 100 )) i
    for (( i=0; i<filled; i++ )); do bbar+='♥'; done
    for (( i=0; i<empty; i++ )); do bbar+='♡'; done
    b_line="hp    ${bbar}  ${battery}%"
    (( battery < 50 )) && hp_color='\033[33m'
    (( battery < 20 )) && hp_color='\033[31m'
  fi

  local type_line=''
  [[ -n "$poke_types" ]] && type_line="type  ${poke_types}"

  local w=${#flavor}
  [[ -n "$type_line" ]] && (( ${#type_line} > w )) && w=${#type_line}
  [[ -n "$b_line" ]]    && (( ${#b_line}    > w )) && w=${#b_line}

  local dots='' j
  for (( j=0; j < w-4; j++ )); do dots+='·'; done

  printf "  ${border}✦ ·· ${dots} ·· ✦${r}\n"
  printf "  ${border}·${r}  ${c}%s${r}%*s  ${border}·${r}\n"           "$flavor"    $(( w - ${#flavor} ))    ""
  [[ -n "$type_line" ]] && \
  printf "  ${border}·${r}  ${type_color}%s${r}%*s  ${border}·${r}\n" "$type_line" $(( w - ${#type_line} )) ""
  [[ -n "$b_line" ]] && \
  printf "  ${border}·${r}  ${hp_color}%s${r}%*s  ${border}·${r}\n"   "$b_line"    $(( w - ${#b_line} ))    ""
  printf "  ${border}✦ ·· ${dots} ·· ✦${r}\n\n"
}
command -v pokeget >/dev/null 2>&1 && _pokemon_welcome

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

eval "$(zoxide init zsh)"
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"
command -v atuin  >/dev/null 2>&1 && eval "$(atuin init zsh)"

# fzf keybindings + completion
if [ -n "$HOMEBREW_PREFIX" ]; then
  [ -f "$HOMEBREW_PREFIX/opt/fzf/shell/keybindings.zsh" ] && \
    source "$HOMEBREW_PREFIX/opt/fzf/shell/keybindings.zsh"
  [ -f "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh" ] && \
    source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
fi

precmd() { mommy -1 -s $? }
alias neofetch="neowofetch"
