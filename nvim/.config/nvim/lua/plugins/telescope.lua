return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find help tags" },
		{ "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
		{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
		{ "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
		{ "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Search for word under cursor" },
		{ "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find", desc = "Search in current buffer" },
		{
			"<leader>fn",
			function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "Search NeoVim config",
		},
	},
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				mappings = {
					i = {
						-- This is the magic action that sends all results to the quickfix list
						["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
					},
					n = {
						["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
					},
				},
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
	end,
}
