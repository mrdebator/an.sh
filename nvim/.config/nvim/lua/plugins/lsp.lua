-- This file is solely responsible for the Language Server Protocol (LSP) ecosystem.
-- It ensures that language servers are installed (Mason), that they are configured to work with
-- Neovim's LSP client (mason-lspconfig), and that the core LSP client itself is set up (nvim-lspconfig).

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local on_attach = function(client, bufnr)
			local map = vim.keymap.set
			map("n", "K", vim.lsp.buf.hover, opts) -- Show documentation for symbol under cursor
			map("n", "gd", vim.lsp.buf.definition, opts) -- Go to definition
			map("n", "gD", vim.lsp.buf.declaration, opts) -- Go to declaration
			map("n", "gi", vim.lsp.buf.implementation, opts) -- Go to implementation
			map("n", "gr", vim.lsp.buf.references, opts) -- List references
			map("n", "<leader>rn", vim.lsp.buf.rename, opts) -- Rename symbol
			map("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Show code actions
			map("n", "<leader>d", vim.diagnostic.open_float, opts) -- Show line diagnostics
			map("n", "[d", vim.diagnostic.goto_prev, opts) -- Go to previous diagnostic
			map("n", "]d", vim.diagnostic.goto_next, opts) -- Go to next diagnostic
			map("n", "<leader>F", function() -- Format file
				require("conform").format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 500,
				})
			end, { desc = "Format file" })
		end

		-- Capabilities are a way for the client (Neovim) to tell the server
		-- what features it supports. We get the default capabilities and then enhance
		-- them with the capabilities from nvim-cmp (for autocompletion).
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		require("mason-lspconfig").setup({
			-- A list of servers to automatically install.
			ensure_installed = {
				"bashls",
				"buf_ls",
				"clangd",
				"gopls",
				"marksman",
				"pyright",
				"rust_analyzer",
				"ts_ls",
			},
			-- provide a single setup function that will be
			-- automatically applied to every server unless overridden.
			setup = {
				-- The default setup function
				default_setup = function(server_name, config)
					config.on_attach = on_attach
					config.capabilities = capabilities
					require("lspconfig")[server_name].setup(config)
				end,
				-- Custom setup for gopls
				gopls = function(_, config)
					config.on_attach = on_attach
					config.capabilities = capabilities
					config.settings = {
						gopls = {
							analyses = {
								unusedparams = true,
							},
							staticcheck = true,
						},
					}
					require("lspconfig").gopls.setup(config)
				end,
				-- Custom setup for pyright
				pyright = function(_, config)
					config.on_attach = on_attach
					config.capabilities = capabilities
					config.settings = {
						python = {
							analysis = {
								typeCheckingMode = "basic",
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
							},
						},
					}
					require("lspconfig").pyright.setup(config)
				end,
			},
		})

		-- Custom Bazel setup
		require("lspconfig").starlark_rust.setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end,
}
