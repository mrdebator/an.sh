-- This file defines the neo-tree file explorer

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    keys = {
        {
            "<leader>e",
            function()
                require("neo-tree.command").execute({ toggle = true })
            end,
            desc = "Toggle NeoTree",
        },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("neo-tree").setup({
            sources = { "filesystem", "buffers", "git_status", "document_symbols" },
            window = {
                position = "right",
                width = 40,
                mappings = {
                  ["a"] = "add",            -- "a" to add a file or directory
                  ["r"] = "rename",         -- "r" to rename
                  ["d"] = "delete",         -- "d" to delete
                  ["c"] = "copy_to_clipboard", -- "c" to copy the path
                  ["x"] = "cut_to_clipboard",  -- "x" to cut
                  ["p"] = "paste_from_clipboard", -- "p" to paste
                  ["b"] = function()
                        require("neo-tree.command").execute({ toggle = true, source = "buffers" })
                    end,
                    ["g"] = function()
                        require("neo-tree.command").execute({ toggle = true, source = "git_status" })
                    end,
                    ["s"] = function()
                        require("neo-tree.command").execute({ toggle = true, source = "document_symbols" })
                    end,
                    ["f"] = function()
                        require("neo-tree.command").execute({ toggle = true, source = "filesystem" })
                    end,
                },
            },
            filesystem = {
                use_libuv_file_watcher = true,
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
                follow_current_file = {
                    enabled = true,
                },
            },
        })

        -- VERTICAL DISTINCTION SETTINGS --

        -- Option 1: Darker background for Neotree
        vim.cmd([[
            augroup NeoTreeColors
                autocmd!
                autocmd FileType neo-tree setlocal winhighlight=Normal:NeoTreeNormal,NormalNC:NeoTreeNormalNC,EndOfBuffer:NeoTreeEndOfBuffer
            augroup END

            " Define the colors (Tokyo Night compatible)
            highlight NeoTreeNormal guibg=#1f2335
            highlight NeoTreeNormalNC guibg=#1f2335
            highlight NeoTreeEndOfBuffer guibg=#1f2335
        ]])

        -- Option 2: More visible separator line
        vim.api.nvim_set_hl(0, "WinSeparator", {
            fg = "#3b4261",  -- Make the vertical line more visible
            bg = "NONE",
        })

        -- Option 3: Add a border character (optional - uncomment if you want a different separator style)
        -- vim.opt.fillchars:append({
        --     vert = "┃",  -- Thicker vertical line (alternatives: │ ┃ ┊ ┋ ║)
        -- })
    end,
}
