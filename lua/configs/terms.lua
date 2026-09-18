-- =====================================================================
--  configs/terms.lua
--  Minimal persistent toggle-terminals for splits. Replaces NvChad's
--  nvchad.term for horizontal/vertical splits.
--  (Floating terminal is handled by floaterm.)
-- =====================================================================

local M = {}

local terms = {} -- id -> bufnr

local function shell()
    return vim.o.shell
end

-- Toggle a persistent terminal in a split. `pos` is "sp" or "vsp".
function M.toggle(opts)
    opts = opts or {}
    local pos = opts.pos or "sp"
    local id = opts.id or ("toggle_" .. pos)
    local size = pos == "sp" and 15 or nil

    local buf = terms[id]
    if buf and vim.api.nvim_buf_is_valid(buf) then
        for _, w in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(w) == buf then
                vim.api.nvim_win_close(w, true)
                return
            end
        end
        if pos == "sp" then
            vim.cmd("botright " .. (size or 15) .. "split")
        else
            vim.cmd("botright vsplit")
        end
        vim.api.nvim_set_current_buf(buf)
        vim.cmd("startinsert")
        return
    end

    if pos == "sp" then
        vim.cmd("botright " .. (size or 15) .. "split")
    else
        vim.cmd("botright vsplit")
    end
    vim.cmd("enew")
    buf = vim.api.nvim_get_current_buf()
    vim.fn.termopen({ shell() })
    terms[id] = buf
    vim.cmd("startinsert")
end

-- Open a fresh terminal in a split (no reuse)
function M.new(opts)
    opts = opts or {}
    local pos = opts.pos or "sp"
    if pos == "sp" then
        vim.cmd("botright 15split")
    else
        vim.cmd("botright vsplit")
    end
    vim.cmd("enew")
    local fresh = vim.api.nvim_get_current_buf()
    vim.bo[fresh].bufhidden = "wipe" -- no orphan buffers when the window closes
    vim.fn.termopen({ shell() })
    vim.cmd("startinsert")
end

-- Keymaps (same bindings NvChad provided)
local map = vim.keymap.set
map("t", "<C-x>", "<C-\\><C-N>", { desc = "Terminal escape terminal mode" })
map("n", "<leader>h", function()
    M.new({ pos = "sp" })
end, { desc = "Terminal new horizontal term" })
map("n", "<leader>v", function()
    M.new({ pos = "vsp" })
end, { desc = "Terminal new vertical term" })
map({ "n", "t" }, "<A-h>", function()
    M.toggle({ pos = "sp", id = "htoggleTerm" })
end, { desc = "Terminal toggleable horizontal term" })
map({ "n", "t" }, "<A-v>", function()
    M.toggle({ pos = "vsp", id = "vtoggleTerm" })
end, { desc = "Terminal toggleable vertical term" })

return M
