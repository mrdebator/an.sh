-- Automatic Commands

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Define the autocommand group
local autosave_group = augroup("AutoSaveGroup", { clear = true })

-- The autosave logic
local autosave = function()
    -- Check if the buffer is modifiable, not read-only, and has a name
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" then
        vim.cmd("silent! write")
    end
end

-- Create the autocommands
autocmd({
    -- Events that trigger a save
    "BufLeave",  -- When you leave a buffer (switch files)
    "FocusLost", -- When you leave NeoVim (switch applications)
    -- "CursorHold",   -- After not moving your cursor in Normal mode
    -- "CursorHoldI",  -- After not typing in Insert mode
}, {
    group = autosave_group,
    pattern = "*", -- Apply to all file types
    callback = autosave,
})

autocmd("VimEnter", {
    group = augroup("dashboard", { clear = true }),
    callback = function()
        -- Only show if no files were opened and we're not in a special mode
        if vim.fn.argc() == 0 and vim.fn.line2byte('$') == -1 then
            -- Small delay to ensure everything is loaded
            vim.defer_fn(function()
                require("core.dashboard").show_dashboard()
            end, 10)
        end
    end,
})

-- Highlight yanked text briefly
autocmd("TextYankPost", {
    group = augroup("highlight_yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
    group = augroup("trim_whitespace", { clear = true }),
    pattern = "*",
    callback = function()
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})

-- Manual command to show dashboard
vim.keymap.set('n', '<leader>sd', function()
    require("core.dashboard").show_dashboard()
end, { desc = "Security Dashboard" })

-- :S command for project-wide substitution on the quickfix list.
-- Usage: :S/find_this/replace_with_this/g
vim.api.nvim_create_user_command(
  "S",
  function(opts)
    -- Get the search/replace pattern from the command arguments
    local pattern = table.concat(opts.fargs, " ")
    if pattern == "" then
      print("Error: No substitution pattern provided.")
      return
    end

    -- Run the substitution on every item in the quickfix list
    vim.cmd("cfdo %s/" .. pattern .. "| update")
  end,
  {
    nargs = "*", -- This command takes any number of arguments
    complete = "command",
  }
)
