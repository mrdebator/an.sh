-- ~/.config/nvim/lua/plugins/dap.lua

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- Core UI for the debugger
    {
      "rcarriga/nvim-dap-ui",
      dependencies = {"nvim-neotest/nvim-nio"},
      config = function()
        local dapui = require("dapui")
        dapui.setup()

        -- Automatically open/close dap-ui when a debug session starts/stops
        local dap = require("dap")
        dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
        dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
        dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
      end
    },

    -- Go-specific DAP configuration
    "leoluz/nvim-dap-go",

    -- Shows variable values as virtual text in your buffer
    "theHamsta/nvim-dap-virtual-text",
    
    -- This bridge automatically installs and configures debug adapters from Mason
    {
        "jay-babu/mason-nvim-dap",
        dependencies = { "williamboman/mason.nvim" },
        -- This ensures the debug adapters are installed when you run :Mason
        opts = {
            ensure_installed = { "delve" }, -- The Go debugger
            handlers = {} -- Let mason-nvim-dap handle the setup
        }
    }
  },
  config = function()
    -- This is the key to making launch.json work.
    -- It tells dap to look for and load configurations from this file.
    require("dap.ext.vscode").load_launchjs(nil, {
      delve = {"go"} -- Maps the 'delve' adapter to the 'go' filetype
    })

    -- Configure the helper plugins
    require("dap-go").setup()
    require("nvim-dap-virtual-text").setup()
  end,
}
