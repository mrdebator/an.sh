-- ~/.config/nvim/lua/plugins/mason.lua

return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		-- This setup function will run BEFORE any other plugins that depend on Mason.
		require("mason").setup()

		-- This is now the central place to list ALL tools you want Mason to install.
		require("mason-lspconfig").setup({
			ensure_installed = {
				-- LSPs
				"bashls",
				"buf_ls",
				"bzl",
				"clangd",
				"gopls",
				"marksman",
				"pyright",
				"rust_analyzer",
				"ts_ls",

				-- Formatters
				"black",
				"goimports",
				"prettier",
				"shfmt",
				"stylua",
			},
		})
	end,
}
