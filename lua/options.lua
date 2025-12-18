-- =====================================================================
--  options.lua
--  Extends NvChad default options (require("nvchad.options")) with user
--  preferences. Keep this file focused on editor behavior (indentation,
--  UI toggles, shell override, etc.).
-- =====================================================================

require("nvchad.options") -- load NvChad base options first

local o = vim.o -- shorthand

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
