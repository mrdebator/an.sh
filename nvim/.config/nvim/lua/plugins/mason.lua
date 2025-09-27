-- ~/.config/nvim/lua/plugins/mason.lua

return {
	"williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
    },
    -- We use `config = true` as a clean way to ensure the default setup function runs.
    -- The specific tools will be requested by the plugins that need them.
    config = true,
}
