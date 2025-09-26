-- ~/.config/nvim/lua/plugins/spectre.lua

return {
	"nvim-pack/nvim-spectre",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("spectre").setup({
			default = {
				find = {
					cmd = "rg",
					args = {
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--hidden", -- Search hidden files and directories
					},
				},
			},
		})
	end,
	keys = {
		{
			"<leader>sr",
			function()
				require("spectre").open({ is_insert_mode = true })
			end,
			desc = "Search & Replace (Spectre)",
		},
		{
			"<leader>sw",
			function()
				require("spectre").open_visual({ select_word = true })
			end,
			desc = "Search Word under cursor (Spectre)",
		},
	},
}
