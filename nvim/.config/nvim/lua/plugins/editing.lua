return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      default_file_explorer = true,
      columns = { "icon", "permissions", "size" },
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["q"] = "actions.close",
      },
      view_options = {
        show_hidden = true,
      },
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },
  {
    "numToStr/Comment.nvim",
    opts = {},
  },
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Search & replace" },
    },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>qs", function() require("persistence").load() end,                desc = "Restore session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't save session on exit" },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte", "xml" },
    opts = {},
  },
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Undo tree" },
    },
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",              desc = "Diagnostics (Trouble)" },
      { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics" },
      { "<leader>xs", "<cmd>Trouble symbols toggle<CR>",                  desc = "Symbols (Trouble)" },
    },
    opts = {},
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm direction=float<CR>",      desc = "Terminal (float)" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Terminal (horizontal)" },
    },
    opts = {
      size = 20,
      float_opts = { border = "curved" },
    },
  },
}
