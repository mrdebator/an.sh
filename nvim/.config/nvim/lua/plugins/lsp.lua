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
			local opts = { buffer = bufnr, remap = false }
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

		-- We can now safely get the list of installed servers.
		local servers = require("mason-lspconfig").get_installed_servers()

		for _, server_name in ipairs(servers) do
			local server_config = {
				on_attach = on_attach,
				capabilities = capabilities,
			}

			-- Add your custom settings for gopls
			if server_name == "gopls" then
				server_config.settings = {
					gopls = {
						analyses = { unusedparams = true },
						staticcheck = true,
					},
				}
			end

			-- Add your custom settings for pyright
			if server_name == "pyright" then
				server_config.settings = {
					python = {
						analysis = {
							typeCheckingMode = "basic",
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
						},
					},
				}
			end

			require("lspconfig")[server_name].setup(server_config)
		end
	end,
}
