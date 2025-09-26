-- This file defines the theme.
-- We make it the highest priority to ensure it loads before anything else that needs it.

--[=====[
-- Catppuccin Mocha
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- Other options: "latte", "frappe", "macchiato"
      transparent_background = false,
      styles = {
        comments = { "italic" },
        keywords = { "italic" },
      },
    })
    vim.cmd([[colorscheme catppuccin-mocha]])
  end,
}
--]=====]

--[=====[
-- Rose Pine
return {
  "rose-pine/neovim",
    name = "rose-pine",
  priority = 1000, -- Ensure it loads first
  config = function()
    vim.cmd([[colorscheme rose-pine]])
  end,
}
--]=====]

-- Tokyo Night
return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("tokyonight").setup({
			style = "storm",
			transparent = true,
			terminal_colors = true,
			styles = {
				comments = { italic = true },
				keywords = { italic = true },
				sidebars = "dark",
				floats = "dark",
			},
		})
		vim.cmd([[colorscheme tokyonight]])
	end,
}
