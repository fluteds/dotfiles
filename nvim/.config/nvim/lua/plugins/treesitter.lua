return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "bash", "lua", "python", "javascript", "typescript",
          "tsx", "json", "yaml", "toml", "markdown", "markdown_inline",
          "html", "css", "rust", "go",
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "BufReadPost",
    opts = {
      max_lines = 3,
      trim_scope = "outer",
    },
    keys = {
      { "<leader>uc", "<cmd>TSContextToggle<CR>", desc = "Toggle sticky context" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = { ["]f"] = "@function.outer" },
          goto_prev_start = { ["[f"] = "@function.outer" },
        },
      })
    end,
  },
}
