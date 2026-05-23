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

-- Obsidian
map("n", "<leader>on", "<cmd>ObsidianNew<CR>")
map("n", "<leader>os", "<cmd>ObsidianSearch<CR>")
map("n", "<leader>ot", "<cmd>ObsidianTags<CR>")
map("n", "<leader>od", "<cmd>ObsidianToday<CR>")
map("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>")
map("n", "<leader>ol", "<cmd>ObsidianLinks<CR>")
map("n", "<leader>oo", "<cmd>ObsidianOpen<CR>")
