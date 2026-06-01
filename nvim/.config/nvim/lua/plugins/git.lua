return {
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>",          desc = "Diffview open" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
      { "<leader>gc", "<cmd>DiffviewClose<CR>",         desc = "Diffview close" },
    },
  },
}
