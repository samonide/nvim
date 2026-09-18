-- =====================================================================
--  nvconfig.lua
--  Single source of truth for theme + UI preferences.
--  Previously chadrc.lua (NvChad). Now standalone:
--    * `base46` table is consumed by the base46 theme engine
--    * edit `theme` / `transparency` here, or use <leader>th picker
-- =====================================================================

local M = {}

M.base46 = {
    theme = "midnight_breeze",
    transparency = true,
    hl_add = {},
    hl_override = {
        ["@comment"] = { italic = true },
    },
    integrations = {},
    changed_themes = {},
    theme_toggle = { "midnight_breeze", "flex-light" },
}

M.ui = {
    cmp = {
        icons_left = false,
        style = "default", -- default/flat_light/flat_dark/atom/atom_colored
        abbr_maxwidth = 60,
        format_colors = { lsp = true, icon = "󱓻" },
    },
    telescope = { style = "bordered" }, -- borderless / bordered
    statusline = {
        enabled = true,
        theme = "default", -- default/vscode/vscode_colored/minimal
        separator_style = "default",
        order = nil,
        modules = nil,
    },
    -- Tabline stays disabled; stub kept so base46's tbline
    -- integration compiles without NvChad present.
    tabufline = {
        enabled = false,
        lazyload = true,
        order = { "treeOffset", "buffers", "tabs", "btns" },
        modules = nil,
        bufwidth = 21,
    },
}

-- Stub for base46's nvcheatsheet integration (cheatsheet UI not used)
M.cheatsheet = { theme = "grid" }

return M
