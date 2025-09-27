-- ~/.config/nvim/lua/plugins/formatter.lua

return {
	"stevearc/conform.nvim",
	dependencies = { "williamboman/mason.nvim" },
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	-- by defining the tools here, we co-locate the dependency with the consumer
	opts = function()
		require("mason-registry").ensure_installed = {
			"black",
			"goimports",
			"prettier",
			"shfmt",
			"stylua",
		}
		-- This returns the options table for conform.nvim's setup
		return {
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "gofmt", "goimports" },
				python = { "black" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				sh = { "shfmt" },
				markdown = { "prettier" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		}
	end,
}
