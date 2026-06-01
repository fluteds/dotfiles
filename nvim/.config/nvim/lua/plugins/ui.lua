return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        offsets = {
          { filetype = "neo-tree", text = "Explorer", highlight = "Directory", separator = true },
        },
        diagnostics = "nvim_lsp",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "rose-pine",
        component_separators = "|",
        section_separators = "",
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope = { enabled = false },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
      },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      icons = { mappings = false },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File",    action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File",     action = ":ene | startinsert" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "g", desc = "Find Text",    action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = "󱓧 ", key = "o", desc = "Obsidian",    action = ":ObsidianSearch" },
            { icon = " ", key = "d", desc = "Dotfiles",    action = ":e ~/dotfiles" },
            { icon = " ", key = "q", desc = "Quit",         action = ":qa" },
          },
        },
      },
      notifier = { enabled = true },
      words = { enabled = true },
      scroll = { enabled = true },
      lazygit = { enabled = true },
      gitbrowse = { enabled = true },
    },
    keys = {
      { "<leader>gg", function() require("snacks").lazygit() end,   desc = "Lazygit" },
      { "<leader>gB", function() require("snacks").gitbrowse() end, desc = "Git browse" },
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPost",
    opts = {},
    keys = {
      { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Find TODOs" },
    },
  },
}
