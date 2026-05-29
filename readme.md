# Dotfiles

Rosé Pine inspired dotfiles + rice for macOS. 🐈

This repo uses GNU Stow to symlink everything into place, so edits you make on your Mac are edits to the repo. No copying files around, no merging "local changes" back into version control.

## Setup

All this can be set up *nearly* automatically with one bootstrap script.

- Clone the repo into somewhere on your MacBook (ideally on the `~/` home directory.)
- Run `./install.sh`

Some parts of the setup require `sudo`. You will be prompted in the terminal when required.

> [!WARNING]
> Don't just run the script if you do not know what it does. Fork, review, edit what you do and don't need, then install.

> [!NOTE]
> MTMR is commented out in the Brewfile by default uncomment it if you have a Touch Bar Mac.
>
> As of May 2026, I do not use a touchbar MacBook, so the scripts might break over time. I have no way of testing them.

## What's included

| Category       | Software |
|----------------|----------|
| Shell prompt   | [Oh My Zsh](https://ohmyz.sh) + [Starship](https://starship.rs) |
| Window manager | [yabai](https://github.com/koekeishiya/yabai), [skhd](https://github.com/koekeishiya/skhd), [borders](https://github.com/FelixKratz/JankyBorders) |
| Touch Bar      | [MTMR](https://github.com/Toxblh/MTMR) (optional) uses my [Home Assistant helper.](https://github.com/fluteds/ha-mtmr) |
| Status bar     | [SketchyBar](https://github.com/felixhageloh/Sketchybar) |
| Theme          | [Rosé Pine](https://rosepinetheme.com) |
| IRC client     | [Halloy](https://halloy.squidowl.org) |
| Editor         | [Neovim](https://neovim.io) |
| Terminal       | [Ghostty](https://ghostty.org) |
| File manager   | [Yazi](https://yazi-rs.github.io) |

## How symlinking works

Stow creates symlinks from your home directory to this repo.

Example:

- `~/.config/yabai/yabairc` -> `~/dotfiles/yabai/.config/yabai/yabairc`

That means you can edit config files normally and just commit changes like any other project. It all syncs and no more headscratching over merge conflicts.

## Keybinds

### Yabai (via skhd)

System stats (via SketchyBar scripts)

- Fn + Option + 1: show CPU
- Fn + Option + 2: show memory
- Fn + Option + 3: show battery
- Fn + Option + 4: show disk
- Fn + Option + 5: show current song

Changing focus

- Option + H / J / K / L: focus left / down / up / right

Resizing windows

- Control + Option + H: resize left
- Control + Option + J: resize down
- Control + Option + K: resize up
- Control + Option + L: resize right
- Control + Option + E: equalize window sizes
- Control + Option + G: toggle gaps / padding

Moving windows

- Shift + Option + H / J / K / L: move window left / down / up / right

Moving windows to workspaces

- Shift + Option + M: send window to last active desktop
- Shift + Option + P: send window to previous workspace
- Shift + Option + N: send window to next workspace
- Shift + Option + 1-4: send window to workspace 1 through 4

Rotating windows

- Option + R: rotate clockwise
- Shift + Option + R: rotate counterclockwise
- Shift + Option + X: flip on the x-axis
- Shift + Option + Y: flip on the y-axis

Setting insertion point

- Shift + Control + Option + H / J / K / L: set insertion point west / south / north / east

Floating windows

- Shift + Option + Space: float / unfloat window
- Option + C: float focused window and center it (press again to retile)

Fullscreen

- Option + F: zoom fullscreen
- Shift + Option + F: native fullscreen

Restart Yabai

- Shift + Control + Option + R: restart Yabai

App focus

- Option + B: Firefox Nightly
- Option + O: Obsidian
- Option + T: Ghostty
