-- This file defines the theme.
-- We make it the highest priority to ensure it loads before anything else that needs it.
return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("tokyonight").setup({
            style = "night",
            transparent = false,
            styles = {
                comments = { italic = true },
                keywords = { italic = true },
            },
        })
        vim.cmd([[colorscheme tokyonight]])
    end,
}

