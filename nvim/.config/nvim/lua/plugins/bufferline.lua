-- Configuration for the top bar to show open buffers
return {
	"akinsho/bufferline.nvim",
	-- This plugin has a C component, so it needs to be built
	build = ":BufferLineCycleNext",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("bufferline").setup({
			options = {
				-- Use "buffers" to show all open buffers
				mode = "buffers",
				-- Use a pre-configured separator style
				separator_style = "padded_space",
				-- Show a close icon on the tabs
				show_buffer_close_icons = true,
				show_close_icon = true,
				-- Add an offset to avoid conflicts with other UI elements
				offsets = {
					{
						filetype = "neo-tree",
						text = "File Explorer",
						highlight = "Directory",
						text_align = "left",
					},
				},
			},
		})

		-- Keymaps for navigating buffers
		vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
		vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
		vim.keymap.set("n", "<leader>bc", "<Cmd>bdelete<CR>", { desc = "Close buffer" })
	end,
}
