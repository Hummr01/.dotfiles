return {
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk_engines = { _ = "-xelatex" }
      vim.g.vimtex_quickfix_enabled = 0
    end,
    keys = {
      { "<leader>l", "", desc = "+latex" },
      { "<leader>ll", "<cmd>VimtexCompile<cr>", desc = "VimTeX: Launch/Toggle Compile" },
      { "<leader>lv", "<cmd>VimtexView<cr>", desc = "VimTeX: View PDF" },
      { "<leader>ls", "<cmd>VimtexStop<cr>", desc = "VimTeX: Stop Compilation" },
      { "<leader>lt", "<cmd>VimtexToggleMain<cr>", desc = "VimTeX: Toggle Main" },
      { "<leader>lc", "<cmd>VimtexClean<cr>", desc = "VimTeX: Clean Aux Files" },
      { "<leader>lf", "<cmd>VimtexView<cr>", desc = "VimTeX: Forward Search" },
    },
  },
}
