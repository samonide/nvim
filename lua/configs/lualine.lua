-- =====================================================================
--  configs/lualine.lua
--  Statusline. Theme comes from Caelestia's scheme.json (transparent),
--  rebuilt automatically on every colorscheme change.
-- =====================================================================

local theme = require("configs.caelestia").lualine_theme()

require("lualine").setup({
    options = {
        theme = theme,
        component_separators = "",
        section_separators = "",
        globalstatus = true,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
})
