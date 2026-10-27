return {
  -- Hyprland Treesitter grammar
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "hyprlang",
      },
    },
  },

  -- Hyprland LSP server (hyprls) via Mason/lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        hyprls = {},
      },
    },
  },

  -- Automatic indentation style detection
  {
    "NMAC427/guess-indent.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}
