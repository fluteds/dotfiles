return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    cmd = { "ObsidianSearch", "ObsidianNew", "ObsidianToday", "ObsidianOpen", "ObsidianTags" },
    dependencies = { "nvim-lua/plenary.nvim", "MeanderingProgrammer/render-markdown.nvim" },
    opts = {
      workspaces = {
        {
          name = "notes",
          path = "~/Documents/Notes",
        },
      },
      daily_notes = {
        folder = "02. Daily",
        date_format = "%d-%m-%y",
        template = nil,
      },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      new_notes_location = "notes_subdir",
      wiki_link_func = function(opts)
        return require("obsidian.util").wiki_link_id_prefix(opts)
      end,
      follow_url_func = function(url)
        vim.fn.jobstart({ "open", url })
      end,
      ui = {
        enable = true,
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
          [">"] = { char = "", hl_group = "ObsidianRightArrow" },
          ["-"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        },
      },
    },
  },
}
