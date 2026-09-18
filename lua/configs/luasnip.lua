-- =====================================================================
--  configs/luasnip.lua
--  LuaSnip setup + snippet loaders. Vendored from NvChad
--  (nvchad.configs.luasnip).
-- =====================================================================

require("luasnip").config.set_config({
    history = true,
    updateevents = "TextChanged,TextChangedI",
})

-- vscode format
require("luasnip.loaders.from_vscode").lazy_load({ exclude = vim.g.vscode_snippets_exclude or {} })
require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.g.vscode_snippets_path or "" })

-- snipmate format
require("luasnip.loaders.from_snipmate").load()
require("luasnip.loaders.from_snipmate").lazy_load({ paths = vim.g.snipmate_snippets_path or "" })

-- lua format
require("luasnip.loaders.from_lua").load()
require("luasnip.loaders.from_lua").lazy_load({ paths = vim.g.lua_snippets_path or "" })

-- fix luasnip #258: unlink snippet session on leaving insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
    group = vim.api.nvim_create_augroup("LuaSnipUnlink", { clear = true }),
    callback = function()
        if
            require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
            and not require("luasnip").session.jump_active
        then
            require("luasnip").unlink_current()
        end
    end,
})
