-- This file configures the Language Server Protocol (LSP) for code intelligence.

return {
    -- LSP Configuration
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "folke/neodev.nvim",
        },
        config = function()
            -- Setup mason for auto-installing LSP servers
            require("mason").setup({
                ensure_installed = {
                    "bzl",
                    "shellcheck",
                    "stylua",
                },
            })
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "bashls",        -- Shell
                    "buf_ls",        -- Protobuf
                    "clangd",        -- C/C++
                    "gopls",         -- Go
                    "marksman",      -- Markdown
                    "pyright",       -- Python
                    "rust_analyzer", -- Rust
                    "ts_ls",         -- TypeScript/JavaScript
                },
            })

            -- Setup neodev for Neovim Lua development
            require("neodev").setup()

            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Keymaps for when LSP attaches
            local on_attach = function(client, bufnr)
                local opts = { buffer = bufnr, remap = false }
                local map = vim.keymap.set

                map("n", "K", vim.lsp.buf.hover, opts)                 -- Show documentation for symbol under cursor
                map("n", "gd", vim.lsp.buf.definition, opts)           -- Go to definition
                map("n", "gD", vim.lsp.buf.declaration, opts)          -- Go to declaration
                map("n", "gi", vim.lsp.buf.implementation, opts)       -- Go to implementation
                map("n", "gr", vim.lsp.buf.references, opts)           -- List references
                map("n", "<leader>rn", vim.lsp.buf.rename, opts)       -- Rename symbol
                map("n", "<leader>ca", vim.lsp.buf.code_action, opts)  -- Show code actions
                map("n", "<leader>d", vim.diagnostic.open_float, opts) -- Show line diagnostics
                map("n", "[d", vim.diagnostic.goto_prev, opts)         -- Go to previous diagnostic
                map("n", "]d", vim.diagnostic.goto_next, opts)         -- Go to next diagnostic
                map("n", "<leader>f", vim.lsp.buf.format, opts)        -- Format
            end

            -- Configure each LSP server
            local servers = {
                bashls = {},
                buf_ls = {},
                clangd = {},
                gopls = {
                    settings = {
                        gopls = {
                            analyses = {
                                unusedparams = true,
                            },
                            staticcheck = true,
                        },
                    },
                },
                marksman = {},
                pyright = {
                    settings = {
                        python = {
                            analysis = {
                                typeCheckingMode = "basic",
                                -- For virtual environments
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                            },
                        },
                    },
                },
                ts_ls = {},
            }

            for server, config in pairs(servers) do
                config.capabilities = capabilities
                config.on_attach = on_attach
                lspconfig[server].setup(config)
            end

            -- Bazel support (using Starlark LSP)
            lspconfig.starlark_rust.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
        end,
    },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end,
    },
}
