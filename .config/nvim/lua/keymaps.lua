-- [[ Basic Keymaps ]]
-- See `:help vim.keymap.set()`

local map = vim.keymap.set

-- Clear highlights on search when pressing <Esc> in normal mode
-- See `:help hlsearch`
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
map("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Diagnostic keymaps
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- TIP: Disable arrow keys in normal mode
-- Add descriptions to these as well for better clarity in which-key
map("n", "<left>", '<cmd>echo "Use h to move!!"<CR>', { desc = "Use h for left" })
map("n", "<right>", '<cmd>echo "Use l to move!!"<CR>', { desc = "Use l for right" })
map("n", "<up>", '<cmd>echo "Use k to move!!"<CR>', { desc = "Use k for up" })
map("n", "<down>", '<cmd>echo "Use j to move!!"<CR>', { desc = "Use j for down" })

-- Keybinds to make split navigation easier.
-- Use CTRL+<hjkl> to switch between windows
--
-- See `:help wincmd` for a list of all window commands
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
