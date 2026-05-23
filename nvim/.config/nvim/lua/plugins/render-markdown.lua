return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "obsidian" },
    opts = {
      checkbox = {
        enabled = true,
        unchecked = { icon = "󰄱" },
        checked = { icon = "󰱒" },
      },
      heading = {
        enabled = true,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      code = {
        enabled = true,
        style = "full",
      },
    },
  },
}
