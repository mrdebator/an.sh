-- This file contains custom key mappings.

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Keep cursor centered during scrolling and searching
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- Move selected lines up and down
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Better paste: paste without losing the text in the paste register
map("x", "<leader>p", [["_dP]], opts)

-- WRAPPED LINE NAVIGATION --

-- When text is wrapped, j and k move by display lines, not actual lines
map("n", "j", "gj", opts)
map("n", "k", "gk", opts)
map("v", "j", "gj", opts)
map("v", "k", "gk", opts)

-- Optional: Use arrow keys for actual line movement when needed
map("n", "<Down>", "gj", opts)
map("n", "<Up>", "gk", opts)

-- Home and End keys work with wrapped lines
map("n", "0", "g0", opts)
map("n", "$", "g$", opts)
map("v", "0", "g0", opts)
map("v", "$", "g$", opts)

-- Toggle wrap on/off if needed
map("n", "<leader>w", ":set wrap!<CR>", opts)

-- WINDOW AND BUFFER MANAGEMENT --

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Buffer management
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)
map("n", "<leader>c", ":bdelete<CR>", opts)

-- Quick Quit Shortcuts
map("n", "<leader>wq", ":wqa<CR>", { desc = "Save and quit all" })
map("n", "<leader>qq", ":qa!<CR>", { desc = "Force quit all"})

-- PLUGIN SHORTCUTS --

-- File tree toggle
-- map("n", "<leader>e", ":NeoTree toggle<CR>", opts)
-- This definition has been moved to ../plugins/neo-tree.lua

-- Telescope fuzzy finding
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)

-- Lazygit toggle
map("n", "<leader>gg", "<cmd>LazyGit<cr>", opts)

-- =======================================================================
-- DEBUGGER (DAP)
-- =======================================================================
map("n", "<leader>dc", function() require("dap").continue() end, { desc = "Debug: Continue" })
map("n", "<leader>dj", function() require("dap").step_over() end, { desc = "Debug: Step Over (Next Line)" })
map("n", "<leader>dk", function() require("dap").step_into() end, { desc = "Debug: Step Into (Function)" })
map("n", "<leader>do", function() require("dap").step_out() end, { desc = "Debug: Step Out" })
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Debug: Toggle Breakpoint" })
map("n", "<leader>dr", function() require("dap").repl.open() end, { desc = "Debug: Open REPL" })
map("n", "<leader>dl", function()
  -- This is the keymap that opens your launch.json configurations
  require("dap").run_last()
end, { desc = "Debug: Launch Last" })
