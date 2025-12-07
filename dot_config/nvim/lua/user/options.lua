local opt = vim.opt

-- == LINE & VISUALS ==
opt.number = true               -- Make line numbers default
opt.relativenumber = true       -- Show relative line numbers
opt.showmode = false            -- Don't show the mode (it's in the status line)
opt.signcolumn = "yes"          -- Keep signcolumn on by default
opt.cursorline = true           -- Show which line your cursor is on
opt.scrolloff = 10              -- Minimal number of screen lines to keep above and below the cursor.

-- == SPLITS & BUFFERS ==
opt.splitright = true           -- Configure how new splits should be opened
opt.splitbelow = true           -- Configure how new splits should be opened
opt.confirm = true              -- Confirm on operations that would fail due to unsaved changes
opt.undofile = true             -- Save undo history
opt.breakindent = true          -- Enable break indent

-- == INDENTATION ==
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true

-- == TIMING & PERFORMANCE ==
opt.updatetime = 250            -- Decrease update time
opt.timeoutlen = 300            -- Decrease mapped sequence wait time

-- == SEARCHING ==
opt.ignorecase = true           -- Case-insensitive searching
opt.smartcase = true            -- UNLESS \C or one or more capital letters in the search term
opt.inccommand = "split"        -- Preview substitutions live

-- == WHITESPACE VISUALS ==
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- == CLIPBOARD ==
vim.schedule(function()
    opt.clipboard = "unnamedplus"
end)
