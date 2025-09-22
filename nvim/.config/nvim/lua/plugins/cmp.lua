-- This file is solely responsible for the autocompletion ecosystem.
-- It configures the main completion engine (nvim-cmp), the snippet engine (LuaSnip),
-- and all the sources that provide completion suggestions.

return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter", -- Load the plugin only when we enter insert mode
        dependencies = {
            "hrsh7th/cmp-nvim-lsp", -- For LSP completions
            "hrsh7th/cmp-buffer", -- For completions from the current buffer
            "hrsh7th/cmp-path", -- For file path completions
            "saadparwaiz1/cmp_luasnip", -- For snippet completions
            "L3MON4D3/LuaSnip", -- snippet engine, nvim-cmp uses this to expand snippets
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
                -- keybindings for the completion menu
                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                -- This defines the order of completion sources.
                -- nvim-cmp will get suggestions from nvim_lsp and luasnip first,
                -- then from the buffer and file paths.
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
