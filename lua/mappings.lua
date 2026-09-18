-- =====================================================================
--  mappings.lua
--  Standalone keymaps (no NvChad dependency). Base defaults vendored
--  from NvChad (nvchad.mappings); custom keymaps below.
--  All custom keymaps carry `desc` for WhichKey visibility.
-- =====================================================================

pcall(require, "configs.disable_signature") -- ensure signature popups are disabled early

-- Always enable line numbers + relative numbers on startup
-- (clipboard = unnamedplus lives in options.lua)
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
    pattern = { "starter", "ministarter" },
    callback = hide_nums,
})
vim.api.nvim_create_autocmd("User", {
    group = hidegrp,
    pattern = { "MiniStarterOpened" },
    callback = hide_nums,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
    group = hidegrp,
    callback = function(args)
        local ft = vim.bo[args.buf].filetype
        if ft == "starter" or ft == "ministarter" then
            hide_nums()
        end
    end,
})

local map = vim.keymap.set

-- ---------------- Base defaults (ex-NvChad) ----------------
-- Insert-mode cursor movement
map("i", "<C-b>", "<ESC>^i", { desc = "Move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "Move end of line" })
map("i", "<C-h>", "<Left>", { desc = "Move left" })
map("i", "<C-l>", "<Right>", { desc = "Move right" })
map("i", "<C-j>", "<Down>", { desc = "Move down" })
map("i", "<C-k>", "<Up>", { desc = "Move up" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "Copy whole file" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "Toggle line number" })

map({ "n", "x" }, "<leader>fm", function()
    require("conform").format({ lsp_fallback = true })
end, { desc = "Format file" })

-- Diagnostics loclist
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- Comment (native gc + remap)
map("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "Toggle comment", remap = true })

-- File explorer
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Nvimtree toggle window" })

-- Extra telescope pickers
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "Telescope find marks" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Telescope find in current buffer" })
map(
    "n",
    "<leader>fa",
    "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
    { desc = "Telescope find all files" }
)

-- Caelestia manual refresh (auto-updates via watcher; this is a fallback)
map("n", "<leader>th", "<cmd>colorscheme caelestia<cr>", { desc = "Refresh caelestia theme" })

-- WhichKey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "Whichkey all keymaps" })
map("n", "<leader>wk", function()
    vim.cmd("WhichKey " .. vim.fn.input("WhichKey: "))
end, { desc = "Whichkey query lookup" })

-- ---------- Core QoL --------------------------------------------------
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert (jk)" })

-- =============================================
-- Harpoon (file marks) - requires harpoon2
-- =============================================
map("n", "<leader>ha", function()
    require("harpoon"):list():add()
    vim.notify("Added to Harpoon list")
end, { desc = "Harpoon add file" })
map("n", "<leader>hh", function()
    require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
end, { desc = "Harpoon menu" })
for i = 1, 4 do
    map("n", string.format("<leader>%d", i), function()
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
-- LuaSnip navigation (if using luasnip)
-- =============================================
map({ "i", "s" }, "<C-n>", function()
    local ls = require("luasnip")
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, { desc = "LuaSnip expand or jump forward" })
map({ "i", "s" }, "<C-p>", function()
    local ls = require("luasnip")
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, { desc = "LuaSnip jump backward" })

-- =============================================
-- Window Navigation
-- =============================================
map("n", "<C-h>", "<C-w>h", { desc = "Focus left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus down split" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus up split" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus right split" })

-- =============================================
-- Additional Productivity Keymaps
-- =============================================

-- Better movement in wrapped lines
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Move down (wrap-aware)" })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Move up (wrap-aware)" })

-- Deletes go to black hole register (keep system clipboard for yanks only)
map("n", "d", '"_d', { desc = "Delete (void register)" })
map("n", "dd", '"_dd', { desc = "Delete line (void register)" })
map("n", "D", '"_D', { desc = "Delete to EOL (void register)" })
map("n", "x", '"_x', { desc = "Delete char (void register)" })
map("v", "d", '"_d', { desc = "Delete selection (void register)" })
map("v", "x", '"_x', { desc = "Delete selection (void register)" })

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

-- Quick quit/close
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit window" })
map("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit all" })

-- Clear search highlighting
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Double-Esc leaves terminal mode (single Esc still reaches the shell app)
map("t", "<Esc><Esc>", "<C-\\><C-N>", { desc = "Exit terminal mode" })

-- Diagnostic navigation
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>de", vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- Notification history (noice)
map("n", "<leader>nl", "<cmd>Noice<cr>", { desc = "Notification history" })

-- Todo-comments navigation (if plugin installed)
map("n", "]t", function()
    require("todo-comments").jump_next()
end, { desc = "Next todo comment" })
map("n", "[t", function()
    require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })
map("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>", { desc = "Todo list (trouble)" })
map("n", "<leader>xf", "<cmd>TodoTelescope<cr>", { desc = "Todo search (telescope)" })

-- Diffview keymaps
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Git diff view" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "Git file history" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "Git branch history" })

-- Discord Rich Presence toggle (starts ON, matches cord setup)
vim.g.cord_enabled = true
map("n", "<leader>cd", function()
    vim.g.cord_enabled = not vim.g.cord_enabled
    vim.cmd("Cord " .. (vim.g.cord_enabled and "enable" or "disable"))
    vim.notify(
        "Discord RPC " .. (vim.g.cord_enabled and "ON" or "OFF"),
        vim.log.levels.INFO
    )
end, { desc = "Toggle Discord Rich Presence" })

-- =============================================
-- Timesense (complexity analysis & stats)
-- =============================================
map("n", "<leader>tc", "<cmd>Timesense complexity<cr>", { desc = "Timesense complexity analysis" })
map("n", "<leader>tx", "<cmd>Timesense stats<cr>", { desc = "Timesense coding stats" })

-- =============================================
-- Buffer Management
-- =============================================
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete buffer" })
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>ba", "<cmd>%bd|e#|bd#<cr>", { desc = "Close all buffers except current" })
map("n", "<C-Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<C-S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- =============================================
-- Split Management
-- =============================================
map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<cr>", { desc = "Horizontal split" })
map("n", "<leader>sx", "<C-w>q", { desc = "Close split" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize split sizes" })

-- Resize splits with arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- =============================================
-- Telescope (fuzzy finder) shortcuts
-- =============================================
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
map("n", "<leader>fw", "<cmd>Telescope grep_string<cr>", { desc = "Find word under cursor" })
map("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "Find commands" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find keymaps" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document symbols" })

-- =============================================
-- LSP Keybindings
-- =============================================
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "gr", vim.lsp.buf.references, { desc = "Show references" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
map("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format document" })
map("n", "<leader>ls", "<cmd>LspInfo<cr>", { desc = "LSP info" })
map("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })

-- =============================================
-- Quick commands
-- =============================================
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New file" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "<leader>wa", "<cmd>wa<cr>", { desc = "Save all" })

-- =============================================
-- File Explorer (NvimTree/Oil)
-- =============================================
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file explorer" })
map("n", "<leader>ef", "<cmd>NvimTreeFocus<cr>", { desc = "Focus file explorer" })

-- =============================================
-- Git shortcuts (additional to existing diffview)
-- =============================================
map("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Git status" })
map("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git commits" })
map("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Git branches" })
