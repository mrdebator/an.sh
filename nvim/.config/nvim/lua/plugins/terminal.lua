-- ~/.config/nvim/lua/plugins/terminal.lua

return {
	"akinsho/toggleterm.nvim",
	version = "*",
	keys = {
		-- Toggle the terminal (works from Normal mode)
		{ "<leader>tt", "<cmd>ToggleTerm<CR>", mode = "n", desc = "Toggle terminal" },

		-- Toggle the terminal (works from Terminal mode)
		{ "<leader>tt", "<C-\\><C-n><cmd>ToggleTerm<CR>", mode = "t", desc = "Toggle terminal" },

		-- Split the terminal vertically (works from Terminal mode)
		{ "<leader>tv", "<C-\\><C-n><cmd>vsplit | terminal<CR>", mode = "t", desc = "Split terminal vertically" },
		-- Split the terminal horizontally (works from Terminal mode)
		{ "<leader>th", "<C-\\><C-n><cmd>split | terminal<CR>", mode = "t", desc = "Split terminal horizontally" },
		-- Seamless navigation (works from Terminal mode)
		{ "<C-h>", "<C-\\><C-n><C-w>h", mode = "t", desc = "Navigate left" },
		{ "<C-j>", "<C-\\><C-n><C-w>j", mode = "t", desc = "Navigate down" },
		{ "<C-k>", "<C-\\><C-n><C-w>k", mode = "t", desc = "Navigate up" },
		{ "<C-l>", "<C-\\><C-n><C-w>l", mode = "t", desc = "Navigate right" },
	},
	config = function()
		require("toggleterm").setup({
			direction = "horizontal",
			size = 12,
			close_on_exit = false,
			shell = vim.o.shell,
		})
	end,
}
