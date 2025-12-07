local map = vim.keymap.set
local au = vim.api.nvim_create_autocmd

-- == NAVIGATION & MODES ==
-- Exit Insert Mode quickly with 'jj'
map("i", "jj", "<ESC>", { desc = "Exit Insert Mode (jj)" })
-- Clear highlights on search when pressing <Esc> in normal mode
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Window navigation with Ctrl + H/J/K/L
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- == UTILITY ==
-- Open diagnostic quickfix list
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
-- Exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- [[ Basic Autocommands ]]
-- Highlight when yanking (copying) text
au("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- LaTeX / VimTeX Keymaps
-- Compile (Build) and View PDF
map("n", "<leader>ll", "<cmd>VimtexCompile<cr>", { desc = "VimTeX: [L]atex [L]aunch Compile" })
map("n", "<leader>lv", "<cmd>VimtexView<cr>", { desc = "VimTeX: [L]atex [V]iew PDF" })

-- Stop compilation or toggle continuous compilation
map("n", "<leader>ls", "<cmd>VimtexStop<cr>", { desc = "VimTeX: [L]atex [S]top Compilation" })
map("n", "<leader>lt", "<cmd>VimtexToggle<cr>", { desc = "VimTeX: [L]atex [T]oggle Continuous Compilation" })

-- Clean auxiliary files
map("n", "<leader>lc", "<cmd>VimtexClean<cr>", { desc = "VimTeX: [L]atex [C]lean Aux Files" })

-- Forward Search (Editor to Viewer)
-- This is usually not required as View/Compile does it, but good for explicit use.
map("n", "<leader>lf", "<cmd>VimtexView<cr>", { desc = "VimTeX: [L]atex [F]orward Search" })
