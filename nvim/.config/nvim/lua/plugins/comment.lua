-- ~/.config/nvim/lua/plugins/comment.lua

return {
	"numToStr/Comment.nvim",
	-- This is a performance optimization. The plugin will only load when you try to use it.
	event = "VeryLazy",

	keys = {
		{
			"<leader>cc",
			function()
				require("Comment.api").toggle.linewise.current()
			end,
			mode = "n",
			desc = "Toggle comment (current line)",
		},
		{
			"<leader>cc",
			function()
				-- We get the visual selection range and pass it to the API
				local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
				vim.api.nvim_feedkeys(esc, "nx", false)
				require("Comment.api").toggle.linewise(vim.fn.visualmode())
			end,
			mode = "v",
			desc = "Toggle comment (selection)",
		},
	},
	opts = {},
}
