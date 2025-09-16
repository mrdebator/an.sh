-- This is the main entry point for the Neovim configuration.
-- It's responsible for loading all other modules of the config.

-- 1. Load core editor settings (options, keymaps)
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- 2. Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- 3. Load the plugin manager and all plugin configurations
require("lazy").setup("plugins")
