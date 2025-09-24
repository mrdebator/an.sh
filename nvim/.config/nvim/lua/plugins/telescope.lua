return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")

    telescope.setup({
          defaults = {
            -- borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },

            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
                "--hidden",
            },
            sorting_strategy = "ascending",
            file_ignore_patterns = { "node_modules", ".git/" },
          },
          pickers = {
            find_files = {
                hidden = true,
            },
          },
    })

    pcall(telescope.load_extension, "fzf")

    -- Keymaps
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
    vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document symbols" })
    vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
    vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
    vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git branches" })
    vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Search for word under cursor" })
    vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Search in current buffer" })
    vim.keymap.set("n", "<leader>fn", function()
            builtin.find_files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "Search NeoVim config" })
  end,
}
