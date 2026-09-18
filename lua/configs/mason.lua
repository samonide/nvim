-- =====================================================================
--  configs/mason.lua
--  mason configuration. Vendored from NvChad (nvchad.configs.mason).
-- =====================================================================

pcall(dofile, vim.g.base46_cache .. "mason")

require("mason").setup({
    PATH = "skip",

    ui = {
        icons = {
            package_pending = " ",
            package_installed = " ",
            package_uninstalled = " ",
        },
    },

    max_concurrent_installers = 10,
})
