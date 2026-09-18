-- =====================================================================
--  configs/gitsigns.lua
--  gitsigns configuration. Vendored from NvChad (nvchad.configs.gitsigns).
-- =====================================================================

pcall(dofile, vim.g.base46_cache .. "git")

require("gitsigns").setup({
    signs = {
        delete = { text = "󰍵" },
        changedelete = { text = "󱕖" },
    },
})
