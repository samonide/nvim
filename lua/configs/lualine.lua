-- =====================================================================
--  configs/lualine.lua
--  Statusline. Replaces NvChad's built-in statusline.
--  Colors are derived from the active base46 palette so the bar follows
--  the theme; backgrounds stay transparent (matches transparency = true).
-- =====================================================================

local function palette()
    local ok, base46 = pcall(require, "base46")
    if not ok then
        return nil
    end
    local ok_tb, base30 = pcall(base46.get_theme_tb, "base_30")
    local ok16, base16 = pcall(base46.get_theme_tb, "base_16")
    if not (ok_tb and ok16) then
        return nil
    end
    return vim.tbl_extend("force", base30, base16)
end

local c = palette()

-- Transparent lualine theme built from base46 colors
local transparent_theme
if c then
    local mode_hl = function(fg)
        return { fg = fg, bg = "NONE", gui = "bold" }
    end
    transparent_theme = {
        normal = {
            a = mode_hl(c.blue or "#61afef"),
            b = { fg = c.white or "#ffffff", bg = "NONE" },
            c = { fg = c.grey_fg or c.grey or "#888888", bg = "NONE" },
        },
        insert = {
            a = mode_hl(c.green or "#98c379"),
        },
        visual = {
            a = mode_hl(c.purple or "#c678dd"),
        },
        replace = {
            a = mode_hl(c.red or "#e86671"),
        },
        command = {
            a = mode_hl(c.yellow or "#e5c07b"),
        },
        inactive = {
            a = { fg = c.grey or "#888888", bg = "NONE" },
            b = { fg = c.grey or "#888888", bg = "NONE" },
            c = { fg = c.grey or "#888888", bg = "NONE" },
        },
    }
end

require("lualine").setup({
    options = {
        theme = transparent_theme or "auto",
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

-- Rebuild lualine colors after a theme switch
vim.api.nvim_create_autocmd("User", {
    pattern = "NvThemeReload",
    group = vim.api.nvim_create_augroup("LualineThemeReload", { clear = true }),
    callback = function()
        vim.schedule(function()
            package.loaded["configs.lualine"] = nil
            pcall(require, "configs.lualine")
        end)
    end,
})
