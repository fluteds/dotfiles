return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>E", "<cmd>Neotree toggle<CR>", desc = "Neo-tree toggle" },
    },
    opts = {
      window = { width = 30 },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,            desc = "Flash jump" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,      desc = "Flash treesitter" },
    },
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
      local map = vim.keymap.set
      map("n", "<leader>ha", function() harpoon:list():add() end,                            { desc = "Harpoon add file" })
      map("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,   { desc = "Harpoon menu" })
      map("n", "<leader>1",  function() harpoon:list():select(1) end,                       { desc = "Harpoon file 1" })
      map("n", "<leader>2",  function() harpoon:list():select(2) end,                       { desc = "Harpoon file 2" })
      map("n", "<leader>3",  function() harpoon:list():select(3) end,                       { desc = "Harpoon file 3" })
      map("n", "<leader>4",  function() harpoon:list():select(4) end,                       { desc = "Harpoon file 4" })
    end,
  },
}
