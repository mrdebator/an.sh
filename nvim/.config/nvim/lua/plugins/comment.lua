-- ~/.config/nvim/lua/plugins/comment.lua

return {
	"numToStr/Comment.nvim",
	-- This is a performance optimization. The plugin will only load when you try to use it.
	event = "VeryLazy",
	config = function()
		require("Comment").setup({})
	end,
}
