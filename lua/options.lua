-- =====================================================================
--  options.lua
--  Standalone editor options. Base defaults vendored from NvChad
--  (nvchad.options); user preferences below override them.
--  Keep this file focused on editor behavior (indentation, UI toggles,
--  shell override, etc.).
-- =====================================================================

local opt = vim.opt
local o = vim.o
local g = vim.g

-- ---------------- Base defaults (ex-NvChad) ----------------
o.laststatus = 3
o.showmode = false
o.splitkeep = "screen"

o.cursorlineopt = "number"

-- Indenting (base: 2-space; user override below sets 4)
o.expandtab = true
o.smartindent = true

opt.fillchars = { eob = " " }
o.mouse = "a"
o.termguicolors = true -- 24-bit colour (foot, kitty, ghostty, wezterm)

-- Numbers
o.numberwidth = 2
o.ruler = false

-- disable nvim intro
opt.shortmess:append("sI")

o.signcolumn = "yes"

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has("win32") ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH

-- ---------------- User preferences (override base) ----------------

-- Indenting
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4

-- UI improvements
o.scrolloff = 8 -- Keep 8 lines visible above/below cursor
o.sidescrolloff = 8
o.cursorline = true -- Highlight current line
-- o.cursorlineopt ='both' -- to enable both line and number highlight

-- Search improvements
o.ignorecase = true -- Case-insensitive search
o.smartcase = true -- Unless uppercase in search
o.hlsearch = true -- Highlight search results
o.incsearch = true -- Incremental search

-- Better splits
o.splitbelow = true -- Horizontal splits go below
o.splitright = true -- Vertical splits go right

-- Performance
o.updatetime = 250 -- Faster completion (default 4000ms)
o.timeoutlen = 300 -- Faster key sequences

-- Better backup/undo
o.undofile = true -- Persistent undo
o.backup = false
o.writebackup = false
o.swapfile = false

-- Completion
o.completeopt = "menu,menuone,noselect" -- Better completion experience

-- System clipboard (yanks sync; deletes use black hole, see mappings.lua)
o.clipboard = "unnamedplus"

-- Force Neovim internal terminal to use zsh (independent of login shell).
-- This ONLY affects :terminal / jobstart shells inside Neovim.
local zsh_path_candidates = { '/usr/bin/zsh', '/bin/zsh' }
for _, p in ipairs(zsh_path_candidates) do
	if vim.fn.executable(p) == 1 then
		o.shell = p
		vim.env.SHELL = p
		break
	end
end

-- To revert temporarily inside Neovim: :let &shell = '/usr/bin/fish' (or use toggle mapping added in mappings.lua)

-- set filetype for .CBL COBOL files.
-- vim.cmd([[ au BufRead,BufNewFile *.CBL set filetype=cobol ]])
