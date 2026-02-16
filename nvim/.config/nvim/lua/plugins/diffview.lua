return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("diffview").setup({
      view = {
        -- This configures the layout for resolving merge conflicts
        merge_tool = {
          -- "diff3_mixed" is the closest to VSCode:
          -- Top Left: Ours | Top Right: Theirs
          -- Bottom: The final result you are editing
          layout = "diff3_mixed",
          disable_diagnostics = true,
        },
      },
    })
  end,
  keys = {
    -- Quick hotkey to open the merge tool when you hit a conflict
    { "<leader>gm", "<cmd>DiffviewOpen<cr>", desc = "Git: Open Merge Editor" },
    -- Quick hotkey to close it when you're done
    { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Git: Close Merge Editor" },
  }
}
