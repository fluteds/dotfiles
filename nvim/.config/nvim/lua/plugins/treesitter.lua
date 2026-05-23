return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_install = {
          "bash", "lua", "python", "javascript", "typescript",
          "tsx", "json", "yaml", "toml", "markdown", "markdown_inline",
          "html", "css", "rust", "go",
        },
      })
    end,
  },
}
