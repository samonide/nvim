-- =====================================================================
--  chadrc.lua
--  Theme/UI overrides for NvChad. Only set what you need; keep this lean.
--  Reference structure: https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
-- =====================================================================

---@type ChadrcConfig
local M = {}

M.ui = {
    tabufline = { enabled = false },
    },

M.base46 = {
    theme = "bearded-arc",
    transparency = true,

    hl_override = {
        Comment = { italic = true },
        ["@comment"] = { italic = true },
    -- Ensure notify background group has a defined bg to silence warning when transparency is on.
    NotifyBackground = { bg = "#1e2030" },
    },
}

return M
