-- ~/.config/nvim/lua/core/dashboard.lua
local M = {}

function M.create_security_dashboard()
    local lines = {}
    local highlights = {}
    
    -- Header
    table.insert(lines, "")
    table.insert(lines, "  🔒 Neovim Security Status")
    table.insert(lines, "  " .. string.rep("─", 40))
    table.insert(lines, "")
    
    -- Check plugin count and last update
    local lazy_ok, lazy = pcall(require, "lazy")
    if lazy_ok then
        local stats = lazy.stats()
        table.insert(lines, string.format("  📦 Plugins Loaded: %d/%d", stats.loaded, stats.count))
        
        -- Check if lazy-lock.json exists (shows if plugins are locked)
        local lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json"
        if vim.fn.filereadable(lockfile) == 1 then
            table.insert(lines, "     ✓ Plugin versions locked")
        else
            table.insert(lines, "     ⚠️  No lazy-lock.json found")
        end
    else
        table.insert(lines, "  📦 Plugin manager not found")
    end
    
    -- Check LSP servers status (FIXED: use new API)
    table.insert(lines, "")
    table.insert(lines, "  🔧 Language Servers:")
    
    -- Use the new API based on Neovim version
    local clients = {}
    if vim.lsp.get_clients then
        -- Neovim 0.10+
        clients = vim.lsp.get_clients()
    elseif vim.lsp.get_active_clients then
        -- Neovim 0.9 and earlier
        clients = vim.lsp.get_active_clients()
    end
    
    if #clients == 0 then
        table.insert(lines, "     None active")
    else
        for _, client in ipairs(clients) do
            table.insert(lines, string.format("     ✓ %s", client.name))
        end
    end
    
    -- Check for suspicious files/paths
    table.insert(lines, "")
    table.insert(lines, "  🔍 Environment Checks:")
    
    -- Check if running as root (bad practice)
    local id_output = vim.fn.system("id -u 2>/dev/null")
    if vim.v.shell_error == 0 then
        local user_id = id_output:gsub("%s+", "")
        if user_id == "0" then
            table.insert(lines, "     ⚠️  Running as root - NOT RECOMMENDED")
            table.insert(highlights, {line = #lines, hl = "WarningMsg"})
        else
            table.insert(lines, "     ✓ Running as normal user")
        end
    else
        table.insert(lines, "     ℹ Cannot determine user (Windows?)")
    end
    
    -- Check for world-writable config (Unix-like systems only)
    local config_dir = vim.fn.stdpath("config")
    local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
    
    if not is_windows then
        local perms = vim.fn.system("stat -c %a " .. vim.fn.shellescape(config_dir) .. " 2>/dev/null")
        if vim.v.shell_error == 0 then
            perms = perms:gsub("%s+", "")
            if perms:match("[27]$") then
                table.insert(lines, "     ⚠️  Config directory is world-writable!")
                table.insert(highlights, {line = #lines, hl = "ErrorMsg"})
            else
                table.insert(lines, "     ✓ Config permissions OK (" .. perms .. ")")
            end
        end
    end
    
    -- Check for recently modified files
    table.insert(lines, "")
    table.insert(lines, "  📝 Recently Modified Configs:")
    
    if not is_windows then
        local find_cmd = string.format(
            "find %s -type f -name '*.lua' -mtime -1 2>/dev/null | head -5",
            vim.fn.shellescape(config_dir)
        )
        local recent = vim.fn.system(find_cmd)
        
        if vim.v.shell_error == 0 and recent ~= "" then
            for file in recent:gmatch("[^\n]+") do
                local basename = vim.fn.fnamemodify(file, ":t")
                table.insert(lines, "     • " .. basename)
            end
        else
            table.insert(lines, "     None in last 24 hours")
        end
    else
        table.insert(lines, "     Check not available on Windows")
    end
    
    -- Git status of config
    table.insert(lines, "")
    table.insert(lines, "  📊 Config Git Status:")
    local git_cmd = string.format(
        "cd %s && git status --porcelain 2>/dev/null",
        vim.fn.shellescape(config_dir)
    )
    local git_status = vim.fn.system(git_cmd)
    
    if vim.v.shell_error ~= 0 or git_status:match("fatal") then
        table.insert(lines, "     ℹ Not a git repository")
    elseif git_status == "" then
        table.insert(lines, "     ✓ Clean")
    else
        local changes = 0
        for _ in git_status:gmatch("[^\n]+") do
            changes = changes + 1
        end
        table.insert(lines, string.format("     ⚠️  %d uncommitted change(s)", changes))
        table.insert(highlights, {line = #lines, hl = "WarningMsg"})
    end
    
    -- Mason status check
    local mason_ok, mason_registry = pcall(require, "mason-registry")
    if mason_ok then
        table.insert(lines, "")
        table.insert(lines, "  🔨 Mason Packages:")
        local installed = #mason_registry.get_installed_packages()
        table.insert(lines, string.format("     %d package(s) installed", installed))
    end
    
    -- Quick actions
    table.insert(lines, "")
    table.insert(lines, "  " .. string.rep("─", 40))
    table.insert(lines, "")
    table.insert(lines, "  Quick Actions:")
    table.insert(lines, "    [h] :checkhealth    [l] :Lazy")
    table.insert(lines, "    [m] :Mason          [g] :Git status")
    table.insert(lines, "    [u] Update plugins  [q] Quit dashboard")
    table.insert(lines, "    [r] Reload dashboard")
    table.insert(lines, "")
    table.insert(lines, "  Press any other key to start editing")
    
    return lines, highlights
end

function M.show_dashboard()
    -- Create a new buffer
    local buf = vim.api.nvim_create_buf(false, true)
    
    -- Set buffer options
    vim.bo[buf].bufhidden = 'wipe'
    vim.bo[buf].buftype = 'nofile'
    vim.bo[buf].swapfile = false
    
    -- Get dashboard content
    local lines, highlights = M.create_security_dashboard()
    
    -- Set content
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    
    -- Apply highlights
    for _, hl in ipairs(highlights) do
        vim.api.nvim_buf_add_highlight(buf, -1, hl.hl, hl.line - 1, 0, -1)
    end
    
    -- Set buffer name for identification
    vim.api.nvim_buf_set_name(buf, "SecurityDashboard")
    
    -- Set keymaps for quick actions
    local opts = { noremap = true, silent = true, buffer = buf }
    
    -- Quick action keys
    vim.keymap.set('n', 'h', function()
        vim.cmd('bdelete')
        vim.cmd('checkhealth')
    end, opts)
    
    vim.keymap.set('n', 'l', function()
        vim.cmd('bdelete')
        vim.cmd('Lazy')
    end, opts)
    
    vim.keymap.set('n', 'm', function()
        vim.cmd('bdelete')
        vim.cmd('Mason')
    end, opts)
    
    vim.keymap.set('n', 'g', function()
        vim.cmd('bdelete')
        vim.cmd('Git status')
    end, opts)
    
    vim.keymap.set('n', 'u', function()
        vim.cmd('bdelete')
        vim.cmd('Lazy update')
    end, opts)
    
    vim.keymap.set('n', 'q', ':bdelete<CR>', opts)
    
    vim.keymap.set('n', 'r', function()
        vim.cmd('bdelete')
        M.show_dashboard()
    end, opts)
    
    -- Any other key starts normal editing
    local letters = "abcdefijknopstvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    for i = 1, #letters do
        local letter = letters:sub(i, i)
        if not vim.tbl_contains({'h', 'l', 'm', 'g', 'u', 'q', 'r'}, letter) then
            vim.keymap.set('n', letter, function()
                vim.cmd('bdelete')
                vim.cmd('enew')
                -- If it was an insert mode key, enter insert mode
                if vim.tbl_contains({'i', 'a', 'o', 'I', 'A', 'O'}, letter) then
                    vim.cmd('startinsert')
                end
            end, opts)
        end
    end
    
    -- Switch to the buffer
    vim.api.nvim_set_current_buf(buf)
end

-- Optional: Command to manually show dashboard
vim.api.nvim_create_user_command('SecurityDashboard', M.show_dashboard, {})

return M
