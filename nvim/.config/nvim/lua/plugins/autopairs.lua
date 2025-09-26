-- Autopairs

return {
	"windwp/nvim-autopairs",
	-- This is a performance optimization.
	-- The plugin will only load when you enter insert mode.
	event = "InsertEnter",
	config = function()
		local autopairs = require("nvim-autopairs")
		autopairs.setup({
			-- You can leave this empty to use the default settings
			-- Or customize it as needed.
			-- For example, to disable autopairing in Markdown files:
			-- disabled_filetypes = { "markdown" },
		})

		-- This is a bonus feature that makes nvim-cmp and nvim-autopairs work together seamlessly.
		-- When you select a function from the completion menu, it will automatically add the parentheses for you.
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
