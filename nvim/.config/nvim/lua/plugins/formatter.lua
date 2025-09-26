-- This file sets up the conform.nvim formatting engine.

return {
  "stevearc/conform.nvim",
  -- Load this plugin only when a buffer is about to be written (saved)
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  config = function()
    require("conform").setup({
      -- This is the core of the configuration.
      -- It maps file types to a list of formatters to run.
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "gofmt", "goimports" },
        python = { "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        sh = { "shfmt" },
        markdown = { "prettier" },
        -- Add more languages here, for example:
        -- rust = { "rustfmt" },
      },

      -- This is the magic that enables format-on-save.
      format_on_save = {
        -- The timeout is a safeguard. If formatting takes too long, it will be aborted.
        timeout_ms = 500,
        -- This allows the LSP server to be used as a fallback formatter.
        lsp_fallback = true,
      },
    })
  end,
}
