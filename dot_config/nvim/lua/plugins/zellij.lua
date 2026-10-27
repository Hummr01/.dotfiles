return {
  {
    "swaits/zellij-nav.nvim",
    lazy = true,
    event = "VeryLazy",
    keys = {
      { "<c-h>", "<cmd>ZellijNavigateLeft<cr>", { silent = true, desc = "Navigate Left (Nvim/Zellij)" } },
      { "<c-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "Navigate Down (Nvim/Zellij)" } },
      { "<c-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "Navigate Up (Nvim/Zellij)" } },
      { "<c-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "Navigate Right (Nvim/Zellij)" } },
    },
    opts = {},
  },
}
