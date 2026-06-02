return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    cmd = { "ObsidianSearch", "ObsidianNew", "ObsidianToday", "ObsidianOpen", "ObsidianTags" },
    dependencies = { "nvim-lua/plenary.nvim", "MeanderingProgrammer/render-markdown.nvim" },
    config = function(_, opts)
      require("obsidian").setup(opts)
      local search = require("obsidian.search")
      table.insert(search._BASE_CMD, "--follow")
      table.insert(search._SEARCH_CMD, "--follow")
      table.insert(search._FIND_CMD, "--follow")
    end,
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
      notes_subdir = "00. Inbox",
      new_notes_location = "notes_subdir",
      note_id_func = function(title)
        if title ~= nil then
          return title
        else
          return os.date("%d-%m-%y-%H%M")
        end
      end,
      note_frontmatter_func = function(note)
        local out = { tags = note.tags }
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,
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
