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

		local server_overrides = {
			gopls = {
				analyses = {
					unusedparams = true,
				},
				staticcheck = true,
			},
			python = {
				analysis = {
					typeCheckingMode = "basic",
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
				},
			},
		}

		local servers = require("mason-lspconfig").get_installed_servers()

		for _, server_name in ipairs(servers) do
			-- The base configuration that applies to all servers
			local base_config = {
				on_attach = on_attach,
				capabilities = capabilities,
			}

			-- Get any custom settings for this specific server
			local server_specific_config = server_overrides[server_name] or {}

			-- Merge the base and specific config
			local final_config = vim.tbl_deep_extend("force", base_config, server_specific_config)

			-- Configure the server
			vim.lsp.config(server_name, final_config)

			-- Enable the server
			vim.lsp.enable(server_name)
		end

		vim.lsp.config("starlark_rust", {
			capabilities = capabilities,
			on_attach = on_attach,
		})
		vim.lsp.enable("starlark_rust")
	end,
}
