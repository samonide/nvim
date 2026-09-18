-- =====================================================================
--  configs/gitsigns.lua
-- =====================================================================

require("gitsigns").setup({
    signs = {
        delete = { text = "󰍵" },
        changedelete = { text = "󱕖" },
    },
    current_line_blame = true,
})
