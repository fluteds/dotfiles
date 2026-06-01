return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "stylua",
        "prettier",
        "shfmt",
        "ruff",
        "shellcheck",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    keys = {
      { "<leader>lf", function() require("conform").format({ async = true, lsp_fallback = true }) end, desc = "Format buffer" },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
        sh = { "shfmt" },
        bash = { "shfmt" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        python = { "ruff" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function() lint.try_lint() end,
      })
    end,
  },
}
