-- This file explicitly sets up nvim-web-devicons, which is crucial for all other UI plugins.
return {
    "nvim-tree/nvim-web-devicons",
    config = function()
        require("nvim-web-devicons").setup({
            default = true,
        })
    end,
}
