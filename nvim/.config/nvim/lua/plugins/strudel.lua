return {
  {
    "gruvw/strudel.nvim",
    build = "npm ci",
    cmd = { "StrudelLaunch", "StrudelQuit", "StrudelToggle", "StrudelUpdate", "StrudelStop", "StrudelSetBuffer", "StrudelExecute" },
    opts = {},
    init = function()
      vim.filetype.add({ extension = { str = "javascript", std = "javascript", strudel = "javascript" } })
    end,
    config = function(_, opts)
      -- puppeteer 22 pulls a yargs that breaks under Homebrew node 26, so pin jobs to the nvm default
      vim.env.PATH = vim.fn.expand("~/.nvm/versions/node/v20.11.1/bin") .. ":" .. vim.env.PATH
      require("strudel").setup(opts)
    end,
    keys = {
      { "<leader>sl", function() require("strudel").launch() end,     desc = "Strudel launch" },
      { "<leader>sq", function() require("strudel").quit() end,       desc = "Strudel quit" },
      { "<leader>st", function() require("strudel").toggle() end,     desc = "Strudel toggle play/stop" },
      { "<leader>su", function() require("strudel").update() end,     desc = "Strudel update" },
      { "<leader>ss", function() require("strudel").stop() end,       desc = "Strudel stop playback" },
      { "<leader>sb", function() require("strudel").set_buffer() end, desc = "Strudel set buffer" },
      { "<leader>sx", function() require("strudel").execute() end,    desc = "Strudel set buffer and update" },
    },
  },
}
