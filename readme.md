# Dotfiles

Rosé Pine inspired dotfiles + rice for macOS. 🐈

This repo uses GNU Stow to symlink everything into place, so edits you make on your Mac are edits to the repo. No copying files around, no merging "local changes" back into version control.

## Setup

All this can be set up *nearly* automatically with one bootstrap script.

- Clone the repo into somewhere on your MacBook (ideally on the `~/` home directory.)
- Run `./install.sh`

> [!WARNING]
> Don't just run the script if you do not know what it does. Fork, review, edit what you do and don't need, then install.

### Setup notes

- Some parts of the setup require `sudo`. You will be prompted in the terminal when required.

- MTMR is commented out in the Brewfile by default. Uncomment it if you have a Touch Bar Mac and want to try out my touch bar config.

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

### Neovim

Plugin manager: [lazy.nvim](https://github.com/folke/lazy.nvim). `<leader>` is **Space**. Press `<leader>?` inside nvim for the full in-editor cheatsheet.

**Plugins**

| Category | Plugins |
|----------|---------|
| UI | bufferline, lualine, indent-blankline, gitsigns, which-key, snacks (dashboard, notifier, scroll), todo-comments |
| Navigation | neo-tree, telescope, flash, harpoon2 |
| Editing | oil, nvim-autopairs, nvim-surround, Comment.nvim, spectre, persistence, undotree, trouble, toggleterm, nvim-ts-autotag |
| Git | diffview, lazygit (via snacks), git browse (via snacks) |
| LSP | mason + mason-lspconfig, nvim-lspconfig, nvim-cmp + LuaSnip |
| Formatting | conform (stylua, prettier, shfmt, ruff), nvim-lint (ruff, shellcheck) |
| Notes | obsidian.nvim |

**LSP servers:** lua_ls, pyright, ts_ls, rust_analyzer, gopls, bashls

<details>
<summary><strong>Keybinds</strong></summary>

Files & search

- `<leader>e`: Oil file explorer
- `<leader>E`: Neo-tree sidebar toggle
- `<leader>ff / fg / fb / fr`: Find files / grep / buffers / recent
- `<leader>ft`: Find TODOs
- `s / S`: Flash jump / Flash treesitter

Harpoon (bookmark files)

- `<leader>ha`: Pin current file
- `<leader>hh`: Open pinned file menu
- `<leader>1-4`: Jump to pinned file 1–4

LSP & code

- `gd / gr`: Go to definition / references
- `K`: Hover docs
- `<leader>ca`: Code actions
- `<leader>rn`: Rename symbol
- `<leader>lf`: Format buffer
- `<leader>xx / xd / xs`: Diagnostics panel / buffer diagnostics / symbols

Git

- `<leader>gg`: Lazygit
- `<leader>gB`: Open file in browser
- `<leader>gd / gh / gc`: Diffview open / file history / close

Terminal

- `<leader>tt / th`: Floating / horizontal terminal

Obsidian

- `<leader>od`: Today's daily note
- `<leader>on / os / ot`: New note / search / browse tags
- `<leader>ob / ol / oo`: Backlinks / links / open in Obsidian app

Session

- `<leader>qs / ql / qd`: Restore session / restore last / don't save on exit

</details>

### Yabai (via skhd)

<details>
<summary><strong>Keybinds</strong></summary>

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

</details>
