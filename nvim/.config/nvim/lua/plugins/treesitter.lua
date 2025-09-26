-- This file configures nvim-treesitter for advanced syntax highlighting.

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"bash",
				"c",
				"go",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"proto",
				"python",
				"toml",
				"typescript",
				"yaml",
			},
			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,
			-- Automatically install missing parsers when entering buffer
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = {
				enable = true,
			},
		})
	end,
}
