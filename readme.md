# Dotfiles

Rosé Pine inspired dotfiles + rice for macOS. 🐈

This repo uses GNU Stow to symlink everything into place, so edits you make on your Mac are edits to the repo. No copying files around, no merging “local changes” back into version control.

## Setup

All this can be setup with one bootstrap script.

- Clone the repo into somewhere on your MacBook (ideally on the `~/` home directory.)
- Run `chmod +x ./setup.sh`
- Then `./setup.sh`

Some parts of the setup require `sudo`. You will be prompted in the terminal when required.

> [!WARNING]
> Don't just run the script if you do not know what it does. Fork, review, edit what you do and don't need, then install.

For MacBooks without a touchbar, make sure to exclude `mtmr` from the brewfile.

## What’s included

| Category       | Software |
|----------------|----------|
| Shell prompt   | [Oh My Zsh](https://ohmyz.sh) + [Starship](https://starship.rs) |
| Window manager | [yabai](https://github.com/koekeishiya/yabai), [skhd](https://github.com/koekeishiya/skhd), [borders](https://github.com/FelixKratz/JankyBorders) |
| Touch Bar      | [MTMR](https://github.com/Toxblh/MTMR) |
| Status bar     | [SketchyBar](https://github.com/felixhageloh/Sketchybar) |
| Theme          | [Rosé Pine](https://rosepinetheme.com) |
| IRC client     | [Halloy](https://halloy.squidowl.org) |
| Editor         | [Visual Studio Code](https://code.visualstudio.com) |
| Terminal       | [iTerm2](https://iterm2.com) |

## How symlinking works

Stow creates symlinks from your home directory to this repo.

Example:

- `~/.config/yabai/yabairc` -> `~/dotfiles/yabai/.config/yabai/yabairc`

That means you can edit config files normally and just commit changes like any other project. It all syncs and no more headscratching over merge conflicts.

## Keybinds

### Yabai (via skhd)

Changing focus

- Option + H / J / K / L: focus left / down / up / right

Resizing windows

- Control + Option + H: resize left
- Control + Option + J: resize down
- Control + Option + K: resize up
- Control + Option + L: resize right
- Control + Option + E: equalize window sizes

Moving windows

- Shift + Option + H / J / K / L: move window left / down / up / right

Moving windows to workspaces

- Shift + Option + M: send window to last active desktop
- Shift + Option + P: send window to previous workspace
- Shift + Option + N: send window to next workspace
- Shift + Option + 1-9: send window to workspace 1 through 9

Rotating windows

- Option + R: rotate clockwise
- Shift + Option + R: rotate counterclockwise
- Shift + Option + X: flip on the x-axis
- Shift + Option + Y: flip on the y-axis

## Apps  via Homebrew

<details>
<summary>Core utilities & shell</summary>

| Tool | Description |
|------|-------------|
| bash | GNU Bourne Again SHell |
| coreutils | GNU core utilities |
| curl | CLI tool for transferring data |
| wget | Network downloader |
| tree | Display directories as trees |
| jq | JSON processor |
| fzf | Fuzzy finder |
| bat | cat clone with syntax highlighting |
| neofetch | System info tool |
| starship | Cross-shell prompt |
| zsh-autosuggestions | Fish-like autosuggestions |
| zsh-completions | Additional Zsh completions |
| zsh-syntax-highlighting | Syntax highlighting for Zsh |
| tmux | Terminal multiplexer |
| todo-txt | Todo.txt CLI |
| screenresolution | Change screen resolutions |

</details>

<details>
<summary>Development & scripting</summary>

| Tool | Description |
|------|-------------|
| autoconf | Automatic configure script builder |
| just | Task runner similar to make |
| protobuf | Google’s data interchange format |
| readline | GNU readline library |
| libtool | Generic library support |
| gettext | GNU i18n support |
| icu4c | Unicode libraries |
| python@3.13 | Python interpreter |
| node | Node.js runtime |
| php | PHP language |
| go | Go language |
| pnpm | Fast JavaScript package manager |
| pipx | Run Python apps in isolated environments |
| ruby | Ruby language |
| perl | Perl language |
| lua | Lua scripting language |
| luajit | Just-in-time compiler for Lua |

</details>

<details>
<summary>Editors & text tools</summary>

| Tool | Description |
|------|-------------|
| emacs | Extensible text editor |
| neovim | Modern Vim-based editor |
| aspell | Spell checker |
| hunspell | Spell checker |
| md4c | Markdown parser |

</details>

<details>
<summary>Data / terminal visuals</summary>

| Tool | Description |
|------|-------------|
| gnuplot | Graphing utility |
| cbonsai | Bonsai tree in terminal |
| chafa | Terminal image previews |
| amfora | Gemini browser in terminal |
| tuifeed | TUI feed reader |
| goread | TUI RSS reader |
| irssi | Terminal IRC client |
| weechat | Terminal chat client |
| httrack | Website copier |
| yabai | Tiling window manager |
| skhd | Hotkey daemon |
| sketchybar | macOS status bar customization |
| borders | macOS window borders |
| mosh | Remote terminal application |
| telnet | Telnet client |
| socat | Network connector |

</details>

<details>
<summary>Media / audio tools</summary>

| Tool | Description |
|------|-------------|
| ffmpeg | Multimedia framework |
| flac | Free Lossless Audio Codec |
| lame | MP3 encoder |
| rubberband | Audio time-stretching |
| mpg123 | MP3 player and decoder |
| opus | Audio codec |
| speex | Voice codec |
| srt | Secure Reliable Transport |
| spotify_player | Spotify TUI player |
| spicetify-cli | Customize Spotify client |
| switchaudio-osx | Audio output switcher |

</details>

<details>
<summary>Security / networking</summary>

| Tool | Description |
|------|-------------|
| docker | Container platform |
| docker-completion | Shell completions for Docker |
| gnupg | OpenPGP encryption |
| pinentry | GPG password prompt |
| openssl@3 | Secure sockets layer |
| net-snmp | SNMP networking |
| unbound | DNS resolver |
| ngrok | Secure tunnels to localhost |

</details>

<details>
<summary>Misc / other CLI tools</summary>

| Tool | Description |
|------|-------------|
| libserialport | Serial port access |
| sqlite | Lightweight SQL DB |
| libgit2 | Git library |
| gh | GitHub CLI |
| npx | Run npm packages |
| mpdecimal | Decimal arithmetic |
| ncurses | Terminal UI library |
| yt-dlp | YouTube downloader |
| x264 / x265 | Video encoders |

</details>
