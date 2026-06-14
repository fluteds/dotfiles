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
      { "<leader>E", function()
        local path = vim.fn.expand("%:p:h")
        local git_root = vim.fn.system("git -C " .. vim.fn.shellescape(path) .. " rev-parse --show-toplevel 2>/dev/null"):gsub("%s+$", "")
        local dir = (git_root ~= "" and not git_root:match("fatal")) and git_root or vim.fn.getcwd()
        require("neo-tree.command").execute({ action = "focus", source = "filesystem", dir = dir, toggle = true })
      end, desc = "Neo-tree toggle" },
    },
    opts = {
      window = { width = 30 },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = {
          enabled = true,
        },
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
    "tris203/precognition.nvim",
    event = "VeryLazy",
    opts = {
      startVisible = false,
    },
    keys = {
      { "<leader>mp", "<cmd>Precognition toggle<CR>", desc = "Toggle motion hints" },
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
