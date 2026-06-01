local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Better window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Resize windows
map("n", "<C-Up>", "<cmd>resize +2<CR>")
map("n", "<C-Down>", "<cmd>resize -2<CR>")
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>")
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>")

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<CR>")
map("n", "<S-l>", "<cmd>bnext<CR>")

-- Move lines
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor centered when jumping
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Paste without losing register
map("x", "<leader>p", '"_dP')

-- Quick save / quit
map("n", "<leader>w", "<cmd>w<CR>")
map("n", "<leader>q", "<cmd>q<CR>")
map("n", "<leader>Q", "<cmd>qa<CR>")

-- Reload config
map("n", "<leader>R", function()
	vim.cmd("source $MYVIMRC")
	vim.notify("Config reloaded", vim.log.levels.INFO)
end, { desc = "Reload config" })

-- File explorer
map("n", "<leader>e", "<cmd>Oil<CR>")

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>")
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>")
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>")

-- LSP (set in lsp config on attach)
map("n", "<leader>ca", vim.lsp.buf.code_action)
map("n", "<leader>rn", vim.lsp.buf.rename)
map("n", "gd", vim.lsp.buf.definition)
map("n", "gr", vim.lsp.buf.references)
map("n", "K", vim.lsp.buf.hover)
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)

-- Claude Code
map("n", "<leader>oc", function()
	vim.cmd("vsplit | terminal claude")
	vim.cmd("startinsert")
end, { desc = "Open Claude Code in split" })

-- Terminal: escape back to normal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Keybinds cheatsheet
map("n", "<leader>?", function()
	local lines = {
		"  NVIM GUIDE  (<leader> = Spacebar)",
		string.rep("─", 40),
		"",
		"  MODES       Esc always returns to Normal mode",
		"  Normal      Default mode: navigate & run commands",
		"  i / a       Insert before / after cursor",
		"  o / O       New line below / above, enter Insert",
		"  v / V       Select characters / whole lines",
		"  <C-v>       Block select (columns)",
		"  :           Command mode (type :w, :q, etc.)",
		"",
		"  MOVEMENT    (Normal mode)",
		"  h j k l     Arrow keys  ← ↓ ↑ →",
		"  w / b       Jump forward / back by word",
		"  e           Jump to end of word",
		"  0 / $       Start / end of line",
		"  gg / G      Top / bottom of file",
		"  { / }       Prev / next blank line",
		"  <C-d/u>     Half page down / up (stays centred)",
		"",
		"  GOING BACK",
		"  <C-o>       Jump back  (after gd, Telescope, etc.)",
		"  <C-i>       Jump forward",
		"  u           Undo",
		"  <C-r>       Redo",
		"  .           Repeat last change",
		"",
		"  EDITING     (Normal mode)",
		"  dd / yy     Delete / copy the current line",
		"  dw / yw     Delete / copy a word",
		"  p / P       Paste after / before cursor",
		"  x           Delete character under cursor",
		"  r           Replace one character (type new one)",
		"  cw          Delete word and drop into Insert",
		"  <leader>p   Paste and keep original clipboard",
		"  J / K       Move selected lines (Visual mode)",
		"",
		"  SEARCH",
		"  /word       Search forward — Enter to confirm",
		"  n / N       Next / previous match",
		"  *           Search word under cursor",
		"  <Esc>       Clear search highlight",
		"",
		"  SAVE & QUIT",
		"  <leader>w   Save file",
		"  <leader>q   Close window",
		"  <leader>Q   Quit everything",
		"  :w          Save  (command mode)",
		"  :q!         Force quit without saving",
		"  :wq         Save and quit",
		"",
		"  WINDOWS & BUFFERS",
		"  <C-h/j/k/l>  Move between open windows",
		"  <S-h> / <S-l> Prev / next buffer (like tabs)",
		"  <C-↑↓←→>    Resize current window",
		"",
		"  FILES & SEARCH",
		"  <leader>e   File explorer  (edit dirs like a file)",
		"  <leader>E   File tree sidebar",
		"  <leader>ff  Find files",
		"  <leader>fg  Search inside all files",
		"  <leader>fb  Switch between open buffers",
		"  <leader>fr  Recently opened files",
		"  <leader>ft  Find TODO comments",
		"  s / S       Flash jump — type char to jump to it",
		"",
		"  HARPOON     (bookmark files for quick switching)",
		"  <leader>ha  Pin this file",
		"  <leader>hh  Show pinned files",
		"  <leader>1-4 Jump to pinned file 1 / 2 / 3 / 4",
		"",
		"  CODE  (LSP)",
		"  gd          Go to definition  (<C-o> to go back)",
		"  gr          Show all references to this symbol",
		"  K           Show docs / type for thing at cursor",
		"  <leader>ca  Code actions: fixes, auto-imports…",
		"  <leader>rn  Rename symbol everywhere in project",
		"  [d / ]d     Jump to prev / next error or warning",
		"  <leader>lf  Auto-format the file",
		"  <leader>xx  Errors panel  (all files)",
		"  <leader>xd  Errors for this file only",
		"  <leader>xs  Symbols / outline panel",
		"",
		"  GIT",
		"  <leader>gg  Lazygit — full git UI",
		"  <leader>gB  Open current file in browser",
		"  <leader>gd  Diff view",
		"  <leader>gh  This file's git history",
		"  <leader>gc  Close diff view",
		"",
		"  TERMINAL",
		"  <leader>tt  Floating terminal",
		"  <leader>th  Terminal at the bottom",
		"  <Esc><Esc>  Exit terminal → back to Normal",
		"  <leader>oc  Claude Code in a split",
		"",
		"  OBSIDIAN",
		"  <leader>od  Today's daily note",
		"  <leader>on  New note",
		"  <leader>os  Search notes",
		"  <leader>ot  Browse tags",
		"  <leader>ob  Backlinks for this note",
		"  <leader>ol  Links in this note",
		"  <leader>oo  Open note in Obsidian app",
		"",
		"  SESSION & OTHER",
		"  <leader>qs  Restore session for this folder",
		"  <leader>ql  Restore last session",
		"  <leader>qd  Don't save session when quitting",
		"  <leader>sr  Search & replace across project",
		"  <leader>u   Visual undo history tree",
		"  <leader>R   Reload nvim config",
		"  <leader>?   This guide  (q to close)",
	}

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })

	vim.cmd("botright vsplit")
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win, buf)
	vim.api.nvim_win_set_width(win, 64)

	local opts = { buffer = buf, silent = true }
	vim.keymap.set("n", "q",     "<cmd>close<CR>", opts)
	vim.keymap.set("n", "<C-h>", "<C-w>h",         opts)
	vim.keymap.set("n", "<C-l>", "<C-w>l",         opts)
	vim.keymap.set("n", "<C-j>", "<C-w>j",         opts)
	vim.keymap.set("n", "<C-k>", "<C-w>k",         opts)
	vim.keymap.set("n", "<BS>",  "<C-w>h",         opts)
end, { desc = "Keybinds cheatsheet" })

-- Obsidian
map("n", "<leader>on", "<cmd>ObsidianNew<CR>")
map("n", "<leader>os", "<cmd>ObsidianSearch<CR>")
map("n", "<leader>ot", "<cmd>ObsidianTags<CR>")
map("n", "<leader>od", function()
	local month_names = {
		"01-January",
		"02-February",
		"03-March",
		"04-April",
		"05-May",
		"06-June",
		"07-July",
		"08-August",
		"09-September",
		"10-October",
		"11-November",
		"12-December",
	}
	local vault = vim.fn.expand("~/Documents/Notes")

	local function note_info(offset_days)
		local t = os.date("*t", os.time() + offset_days * 86400)
		return {
			filename = string.format("%02d-%02d-%02d", t.day, t.month, t.year % 100),
			folder = string.format("02. Daily/%d/%s", t.year, month_names[t.month]),
		}
	end

	local today = note_info(0)
	local yd = note_info(-1)
	local tm = note_info(1)
	local fullpath = vault .. "/" .. today.folder .. "/" .. today.filename .. ".md"
	local is_new = vim.fn.filereadable(fullpath) == 0

	vim.fn.mkdir(vault .. "/" .. today.folder, "p")
	vim.cmd("e " .. vim.fn.fnameescape(fullpath))

	if is_new then
		local nav =
			string.format("[[%s/%s|Yesterday]] | [[%s/%s|Tomorrow]]", yd.folder, yd.filename, tm.folder, tm.filename)
		local lines = {
			"---",
			"created: " .. os.date("%Y-%m-%dT%H:%M:%S"),
			"tags:",
			"  - daily",
			"---",
			nav,
			"",
			"## Summary",
			"",
			"- ",
			"",
			"## Notes",
			"",
			"- ",
			"",
			"## Thoughts",
			"",
			"- ",
			"",
			"## Mood",
			"",
			"- [ ] Mood: ",
		}
		vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
	end
end, { desc = "Daily note" })
map("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>")
map("n", "<leader>ol", "<cmd>ObsidianLinks<CR>")
map("n", "<leader>oo", "<cmd>ObsidianOpen<CR>")
