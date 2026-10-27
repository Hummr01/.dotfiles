return {
  {
    "folke/sidekick.nvim",
    opts = {
      nes = {
        -- Disable Copilot NES unless you enable a Copilot LSP server
        enabled = false,
      },
      cli = {
        watch = true, -- Automatically notify Neovim of file changes made by OpenCode
        picker = "snacks",
        mux = {
          backend = "zellij",
          enabled = true,
        },
      },
    },
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<c-.>",
        function()
          require("sidekick.cli").focus()
        end,
        desc = "Sidekick Focus",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function()
          require("sidekick.cli").toggle({ name = "opencode", focus = true })
        end,
        desc = "Sidekick Toggle OpenCode",
      },
      {
        "<leader>ao",
        function()
          require("sidekick.cli").toggle({ name = "opencode", focus = true })
        end,
        desc = "Sidekick Toggle OpenCode",
      },
      {
        "<leader>as",
        function()
          require("sidekick.cli").select({ filter = { installed = true } })
        end,
        desc = "Select Installed AI CLI",
      },
      {
        "<leader>ad",
        function()
          require("sidekick.cli").close()
        end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>at",
        function()
          require("sidekick.cli").send({ name = "opencode", msg = "{this}" })
        end,
        mode = { "x", "n" },
        desc = "Send This to OpenCode",
      },
      {
        "<leader>af",
        function()
          require("sidekick.cli").send({ name = "opencode", msg = "{file}" })
        end,
        desc = "Send File to OpenCode",
      },
      {
        "<leader>av",
        function()
          require("sidekick.cli").send({ name = "opencode", msg = "{selection}" })
        end,
        mode = { "x" },
        desc = "Send Visual Selection to OpenCode",
      },
      {
        "<leader>ap",
        function()
          require("sidekick.cli").prompt()
        end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
    },
  },

  -- Integrate Snacks picker with Sidekick (<Alt-a> sends picker items to OpenCode)
  {
    "folke/snacks.nvim",
    optional = true,
    opts = {
      picker = {
        actions = {
          sidekick_send = function(...)
            return require("sidekick.cli.picker.snacks").send(...)
          end,
        },
        win = {
          input = {
            keys = {
              ["<a-a>"] = {
                "sidekick_send",
                mode = { "n", "i" },
              },
            },
          },
        },
      },
    },
  },

  -- Show active Sidekick CLI sessions (OpenCode) in lualine
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, 2, {
        function()
          local status = require("sidekick.status").cli()
          return " " .. (#status > 1 and #status or "")
        end,
        cond = function()
          return package.loaded["sidekick"] and #require("sidekick.status").cli() > 0
        end,
        color = function()
          return { fg = Snacks.util.color("Special") }
        end,
      })
    end,
  },
}
