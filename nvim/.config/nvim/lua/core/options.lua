-- Basic NeoVim settings, like line numbers, tab widths, etc.
-- This file contains core editor settings.

local opt = vim.opt -- for conciseness

-- Line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- Tabs and indentation
opt.tabstop = 4 -- 4 spaces for tabs
opt.shiftwidth = 4 -- 4 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- Search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- Appearance
opt.termguicolors = true -- enable 24-bit RGB colors
opt.background = "dark" -- tell vim what the background color looks like
opt.signcolumn = "yes" -- always show the sign column
opt.cursorline = true
opt.colorcolumn = "120" -- Show a vertical line at column 120 as a guide
-- opt.ambiwidth = "double"   -- Handling ambiguous width characters

-- Vertical Separator
opt.fillchars = {
	eob = " ",
	vert = "|",
}

-- Text Wrapping
opt.wrap = true -- Enable text wrapping
opt.linebreak = true -- Wrap lines at convenient points
opt.breakindent = true -- Wrapped lines continue visually indented
opt.showbreak = "  ↪ " -- Show a symbol on wrapped lines
-- opt.columns = 120        -- Optional: set a column limit

-- Behavior
opt.clipboard:append("unnamedplus") -- sync with system clipboard
opt.swapfile = false -- disable swap files
opt.backup = false -- disable backup files
opt.hidden = true -- switch between files without saving current file
opt.mouse = "a" -- Enable mouse support for all modes

-- Update Time
opt.updatetime = 300

-- Scrolling
opt.scrolloff = 8 -- minimal number of screen lines to keep above and below the cursor

-- Splits
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom
