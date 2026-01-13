-- =====================================================================
--  mappings.lua
--  Extends NvChad default mappings. All custom keymaps are declared with
--  descriptive `desc` for WhichKey & cheatsheet visibility.
--  Sections:
--    * Core quality-of-life
--    * Terminal toggles
--    * Harpoon, Trouble, Overseer, Snippets
-- =====================================================================

require("nvchad.mappings") -- load NvChad defaults first
pcall(require, "configs.disable_signature") -- ensure signature popups are disabled early

-- Always enable line numbers + relative numbers on startup
vim.opt.number = true
vim.opt.relativenumber = true

-- Hide numbers in dashboard-like buffers (robust across UIs)
local hidegrp = vim.api.nvim_create_augroup("HideNumbersOnDashboard", { clear = true })
local function hide_nums()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.cursorline = false
end
vim.api.nvim_create_autocmd("FileType", {
    group = hidegrp,
    pattern = { "alpha", "dashboard", "nvdash", "starter" },
    callback = hide_nums,
})
vim.api.nvim_create_autocmd("User", {
    group = hidegrp,
    pattern = { "AlphaReady", "NvDashReady" },
    callback = hide_nums,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
    group = hidegrp,
    callback = function(args)
        local ft = vim.bo[args.buf].filetype
        if ft == "alpha" or ft == "dashboard" or ft == "nvdash" or ft == "starter" then
            hide_nums()
        end
    end,
})

-- Unmap any default Alt-i to reuse as our floating terminal toggle
pcall(vim.keymap.del, "n", "<A-i>")
pcall(vim.keymap.del, "t", "<A-i>")

local map = vim.keymap.set

-- ---------- Core QoL --------------------------------------------------
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert (jk)" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>") -- Uncomment for Ctrl+S save

-- =============================================
-- Floating terminal helper
-- =============================================
local function make_float_win(buf)
    local width = math.floor(vim.o.columns * 0.9)
    local height = math.floor(vim.o.lines * 0.85)
    return vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
    })
end

-- Toggle a single shared floating bash terminal (no rc/history)
local function toggle_floating_bash()
    local win = vim.g._float_bash_win
    local buf = vim.g._float_bash_buf
    if win and vim.api.nvim_win_is_valid(win) then
        pcall(vim.api.nvim_win_close, win, true)
        vim.g._float_bash_win = nil
        return
    end
    if buf and vim.api.nvim_buf_is_valid(buf) then
        vim.g._float_bash_win = make_float_win(buf)
        vim.cmd("startinsert")
        return
    end
    buf = vim.api.nvim_create_buf(false, true)
    vim.g._float_bash_buf = buf
    vim.g._float_bash_win = make_float_win(buf)
    vim.fn.termopen({ "bash", "--noprofile" })
    vim.cmd("startinsert")
end

-- =============================================
-- Harpoon (file marks) - requires harpoon2
-- =============================================
map("n", "<leader>ha", function()
    require("harpoon"):list():add()
    vim.notify("Added to Harpoon list")
end, { desc = "Harpoon add file" })
map("n", "<leader>hm", function()
    require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
end, { desc = "Harpoon menu" })
for i = 1, 4 do
    map("n", string.format("<leader>h%d", i), function()
        require("harpoon"):list():select(i)
    end, { desc = "Harpoon select #" .. i })
end

-- =============================================
-- Trouble diagnostics quick toggles
-- =============================================
map("n", "<leader>td", "<cmd>Trouble diagnostics toggle focus=true<CR>", { desc = "Trouble diagnostics" })
map("n", "<leader>tq", "<cmd>Trouble qflist toggle<CR>", { desc = "Trouble quickfix" })
map("n", "<leader>tr", "<cmd>Trouble lsp_references toggle focus=true<CR>", { desc = "Trouble references" })

-- =============================================
-- Overseer tasks (compile / run orchestrator)
-- =============================================
map("n", "<leader>ot", "<cmd>OverseerToggle<CR>", { desc = "Overseer task list" })
map("n", "<leader>or", "<cmd>OverseerRun<CR>", { desc = "Overseer run task" })

-- =============================================
-- Toggle shell between zsh and fish (Neovim internal terminal only)
-- =============================================
map("n", "<leader>ts", function()
    local current = vim.o.shell
    local zsh = (vim.fn.executable("/usr/bin/zsh") == 1 and "/usr/bin/zsh")
        or (vim.fn.executable("/bin/zsh") == 1 and "/bin/zsh")
    local fish = (vim.fn.executable("/usr/bin/fish") == 1 and "/usr/bin/fish")
        or (vim.fn.executable("/bin/fish") == 1 and "/bin/fish")
    if current == zsh and fish then
        vim.o.shell = fish
        vim.notify("Shell set to fish (Neovim only)")
    elseif zsh then
        vim.o.shell = zsh
        vim.notify("Shell set to zsh (Neovim only)")
    else
        vim.notify("No zsh found; shell unchanged", vim.log.levels.WARN)
    end
end, { desc = "Toggle shell zsh<->fish (nvim term)" })

-- =============================================
-- Terminal toggles
-- =============================================
map("n", "<leader>ft", function()
    -- Toggle a shared floating bash terminal (identical to Alt-i)
    toggle_floating_bash()
end, { desc = "Toggle floating bash terminal" })

-- Alt-i should behave exactly like <leader>ft (toggle open/close)
map({ "n", "t" }, "<A-i>", function()
    toggle_floating_bash()
end, { desc = "Toggle floating bash terminal" })

-- =============================================
-- LuaSnip navigation (if using luasnip)
-- =============================================
map({ "i", "s" }, "<C-j>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, { desc = "LuaSnip expand or jump forward" })
map({ "i", "s" }, "<C-k>", function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, { desc = "LuaSnip jump backward" })

-- =============================================
-- Terminal toggle (Alt-h / Alt-v) and leader h/v for window navigation
-- =============================================

-- Repurpose leader h/v to navigate splits
map("n", "<leader>h", "<C-w>h", { desc = "Focus left split" })
map("n", "<leader>v", "<C-w>l", { desc = "Focus right split" })

-- Horizontal terminal toggle (Alt-h) and Vertical (Alt-v)
local function toggle_term(dir)
    local buf = vim.g.toggle_term_buf
    local buf_valid = buf and vim.api.nvim_buf_is_valid(buf)
    local win_with_buf
    if buf_valid then
        for _, w in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(w) == buf then
                win_with_buf = w
                break
            end
        end
    end

    -- If buffer is currently shown -> close the window (toggle off)
    if buf_valid and win_with_buf then
        pcall(vim.api.nvim_win_close, win_with_buf, true)
        return
    end

    -- If buffer exists but not shown -> show it (direction respected)
    if buf_valid then
        if dir == "v" then
            vim.cmd("botright vsplit")
        else
            vim.cmd("botright 15split")
        end
        vim.api.nvim_set_current_buf(buf)
        vim.cmd("startinsert")
        return
    end

    -- Create new terminal buffer (use bash without rc to avoid neofetch/history)
    if dir == "v" then
        vim.cmd("botright vsplit")
    else
        vim.cmd("botright 15split")
    end
    vim.cmd("enew")
    local new_buf = vim.api.nvim_get_current_buf()
    vim.fn.termopen({ "bash", "--noprofile" })
    vim.g.toggle_term_buf = new_buf
    vim.cmd("startinsert")
end
map("n", "<A-h>", function()
    toggle_term("h")
end, { desc = "Toggle horizontal terminal" })
map("n", "<A-v>", function()
    toggle_term("v")
end, { desc = "Toggle vertical terminal" })

-- =============================================
-- Additional Productivity Keymaps
-- =============================================

-- Better movement in wrapped lines
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Move down (wrap-aware)" })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Move up (wrap-aware)" })

-- Quick save
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })

-- Better indenting (stay in visual mode)
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered on search/jumps
map("n", "n", "nzzzv", { desc = "Next search (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search (centered)" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Better paste (don't lose register in visual mode)
map("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })

-- Delete to void register (don't pollute clipboard)
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete to void" })

-- Quick quit/close
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit window" })
map("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit all" })

-- Clear search highlighting
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Diagnostic navigation
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- Todo-comments navigation (if plugin installed)
map("n", "]t", function()
    require("todo-comments").jump_next()
end, { desc = "Next todo comment" })
map("n", "[t", function()
    require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

-- Diffview keymaps
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Git diff view" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "Git file history" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "Git branch history" })

-- Discord Rich Presence toggle
map("n", "<leader>cd", function()
    local server = require("cord.server")
    local is_paused = server.manager and server.manager.is_paused or false

    -- Toggle presence
    require("cord.api.command").toggle_presence()

    -- Show notification based on the toggle (opposite of current state)
    if is_paused then
        vim.notify("Discord Rich Presence: Enabled 🎮", vim.log.levels.INFO)
    else
        vim.notify("Discord Rich Presence: Disabled 🔇", vim.log.levels.INFO)
    end
end, { desc = "Toggle Discord Rich Presence" })

-- =============================================
-- Timesense (complexity analysis & stats)
-- =============================================
map("n", "<leader>tc", "<cmd>Timesense complexity<cr>", { desc = "Timesense complexity analysis" })
map("n", "<leader>tx", "<cmd>Timesense stats<cr>", { desc = "Timesense coding stats" })
