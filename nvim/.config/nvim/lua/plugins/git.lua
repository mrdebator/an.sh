return {
	-- Git signs in the gutter
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "│" },
					change = { text = "│" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
			})
		end,
	},

	-- Git visualization
	{
		"rbong/vim-flog",
		lazy = true,
		cmd = { "Flog", "Flogsplit", "Floggit" },
		dependencies = {
			"tpope/vim-fugitive",
		},
		keys = {
			{ "<leader>gg", "<cmd>Flog<cr>", desc = "Git graph" },
		},
	},

	-- Fugitive for Git commands
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "G" },
	},
}
