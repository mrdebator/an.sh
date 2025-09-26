-- ~/.config/nvim/lua/plugins/formatter.lua

return {
	"stevearc/conform.nvim",
	dependencies = { "williamboman/mason.nvim" },
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		ensure_installed = {
			"stylua",
			"black",
			"prettier",
			"shfmt",
			"goimports",
		},
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
	},
}
