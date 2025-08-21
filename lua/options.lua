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

-- o.cursorlineopt ='both' -- to enable cursorline!

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
