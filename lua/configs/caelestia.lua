-- =====================================================================
--  configs/caelestia.lua
--  Companion to colors/caelestia.lua. Reads the same scheme.json and
--  derives:
--    * lualine's theme (transparent, follows wallpaper)
--    * extra highlight groups the colorscheme doesn't define
--      (ibl, cmp kinds, LSP references/inlay hints)
--  Re-applies on every ColorScheme so wallpaper switches propagate.
-- =====================================================================

local M = {}

local scheme_path = (vim.env.XDG_STATE_HOME or ((vim.env.HOME or vim.fn.expand("~")) .. "/.local/state"))
    .. "/caelestia/scheme.json"

-- Parsed scheme colours ({ name = "#rrggbb" }). Nil when unreadable.
function M.colours()
    local f = io.open(scheme_path, "r")
    if not f then
        return nil
    end
    local raw = f:read("*a")
    f:close()
    local ok, data = pcall(vim.json.decode, raw)
    if not ok or type(data) ~= "table" or type(data.colours) ~= "table" then
        return nil
    end
    local out = {}
    for k, v in pairs(data.colours) do
        if type(v) == "string" and v:match("^%x%x%x%x%x%x$") then
            out[k] = "#" .. v
        end
    end
    return out
end

-- Transparent lualine theme from scheme colours
function M.lualine_theme()
    local c = M.colours()
    if not c then
        return "auto"
    end
    local mode_hl = function(fg)
        return { fg = fg, bg = "NONE", gui = "bold" }
    end
    local dim = { fg = c.onSurfaceVariant or c.onSurface, bg = "NONE" }
    local faint = { fg = c.outline or c.onSurfaceVariant, bg = "NONE" }
    return {
        normal = { a = mode_hl(c.primary), b = dim, c = faint },
        insert = { a = mode_hl(c.term2) },
        visual = { a = mode_hl(c.term5) },
        replace = { a = mode_hl(c.term1) },
        command = { a = mode_hl(c.term3) },
        inactive = { a = faint, b = faint, c = faint },
    }
end

-- Groups colors/caelestia.lua doesn't define
function M.apply_extras()
    local c = M.colours()
    if not c then
        return
    end
    local hl = function(g, s)
        vim.api.nvim_set_hl(0, g, s)
    end

    -- indent guides
    hl("IblIndent", { fg = c.outlineVariant })
    hl("IblWhitespace", { fg = c.outlineVariant })
    hl("IblScope", { fg = c.primary, bold = true })

    -- completion kinds
    hl("CmpItemKindFunction", { fg = c.term4 })
    hl("CmpItemKindMethod", { fg = c.term4 })
    hl("CmpItemKindVariable", { fg = c.term5 })
    hl("CmpItemKindKeyword", { fg = c.term5 })
    hl("CmpItemKindSnippet", { fg = c.term2 })
    hl("CmpItemKindText", { fg = c.onSurface })
    hl("CmpItemAbbrMatch", { fg = c.primary, bold = true })

    -- LSP references / inlay hints
    local ref_bg = c.surfaceContainerHigh or c.surfaceContainer
    hl("LspReferenceText", { bg = ref_bg })
    hl("LspReferenceRead", { bg = ref_bg })
    hl("LspReferenceWrite", { bg = ref_bg, bold = true })
    hl("LspInlayHint", { fg = c.onSurfaceVariant, italic = true })

    -- dashboard (mini.starter)
    hl("MiniStarterCurrent", { fg = c.onPrimaryContainer, bg = c.primaryContainer, bold = true })
    hl("MiniStarterItemPrefix", { fg = c.primary, bold = true })
    hl("MiniStarterHeader", { fg = c.primary, bold = true })
    hl("MiniStarterFooter", { fg = c.onSurfaceVariant })
    hl("MiniStarterQuery", { fg = c.primary })
    hl("MiniStarterInactive", { fg = c.outline })
end

function M.setup()
    local group = vim.api.nvim_create_augroup("CaelestiaExtras", { clear = true })
    M.apply_extras()
    -- Startup cover: colors/caelestia.lua applies nested inside its own
    -- VimEnter handler, which suppresses ColorScheme propagation.
    -- This hook is registered after it, so it runs after first paint.
    vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        group = group,
        callback = function()
            M.apply_extras()
        end,
    })
    vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        callback = function()
            M.apply_extras()
            vim.schedule(function()
                package.loaded["configs.lualine"] = nil
                pcall(require, "configs.lualine")
            end)
        end,
    })
end

return M
