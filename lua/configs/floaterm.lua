-- =====================================================================
--  configs/floaterm.lua
--  Floaterm setup + Esc-to-close inside float windows.
--  Exit flow: <Esc><Esc> in terminal mode -> normal mode,
--  <Esc> again in normal mode -> close the float.
-- =====================================================================

local M = {}

local function esc_close(buf)
    vim.keymap.set("n", "<Esc>", "<cmd>FloatermToggle<cr>", {
        buffer = buf,
        desc = "Close floating terminal",
    })
end

function M.setup(opts)
    require("floaterm").setup(opts)

    local grp = vim.api.nvim_create_augroup("FloatermEsc", { clear = true })

    -- sidebar buffer has a real filetype
    vim.api.nvim_create_autocmd("FileType", {
        group = grp,
        pattern = "FloatermSidebar",
        callback = function(args)
            esc_close(args.buf)
        end,
    })

    -- term buffers carry no filetype; match them against floaterm state
    vim.api.nvim_create_autocmd("BufEnter", {
        group = grp,
        callback = function(args)
            if vim.bo[args.buf].buftype ~= "terminal" then
                return
            end
            local ok, state = pcall(require, "floaterm.state")
            if not ok or not state.terminals then
                return
            end
            for _, t in ipairs(state.terminals) do
                if t.buf == args.buf then
                    esc_close(args.buf)
                    break
                end
            end
        end,
    })
end

return M
