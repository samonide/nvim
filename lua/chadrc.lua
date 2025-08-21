-- =====================================================================
--  chadrc.lua
--  Theme/UI overrides for NvChad. Only set what you need; keep this lean.
--  Reference structure: https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
-- =====================================================================

---@type ChadrcConfig
local M = {}

M.base46 = {
    theme = "chadracula",
    transparency = true,

    hl_override = {
        -- Comment = { italic = true },
        ["@comment"] = { italic = true },
    },
}

return M
