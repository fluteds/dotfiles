vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- nvim-treesitter v1 removed ft_to_lang; Telescope still calls it
if not vim.treesitter.language.ft_to_lang then
  vim.treesitter.language.ft_to_lang = vim.treesitter.language.get_lang
end

require("config.options")
require("config.lazy")
require("config.keymaps")
