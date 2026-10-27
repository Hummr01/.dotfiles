-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Exit Insert Mode quickly with 'jj'
map("i", "jj", "<Esc>", { noremap = true, silent = true, desc = "Exit Insert Mode (jj)" })

-- Exit Terminal Mode with <Esc><Esc>
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Diagnostic quickfix list
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
