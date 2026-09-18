-- =====================================================================
--  Entry point for this Neovim configuration.
--  Standalone setup (no NvChad dependency, base46 kept for theming).
--  Responsibilities:
--    * Define leader key & theme cache path
--    * Bootstrap lazy.nvim plugin manager
--    * Load plugin specs (lua/plugins) + user options
--    * Apply base46 theme highlights + statusline
-- =====================================================================

vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
vim.g.mapleader = " " -- Space as <leader>

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Bootstrap lazy.nvim if missing (shallow clone stable branch)
if not vim.uv.fs_stat(lazypath) then
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")

require("lazy").setup({ import = "plugins" }, lazy_config)

-- Options first so plugins see user settings
require("options")

-- Compile base46 theme cache on first run, then apply highlights.
-- Recompile on demand via :lua require("base46").load_all_highlights()
if not vim.uv.fs_stat(vim.g.base46_cache .. "defaults") then
    local ok, base46 = pcall(require, "base46")
    if ok then
        base46.load_all_highlights()
    end
end
pcall(dofile, vim.g.base46_cache .. "defaults")
pcall(dofile, vim.g.base46_cache .. "syntax")
pcall(dofile, vim.g.base46_cache .. "treesitter")

require("configs.autocmds")

-- Defer custom mappings & CP template autocmd so core is initialized
vim.schedule(function()
    require("mappings") -- user + extended keymaps
    pcall(require, "configs.cp_template") -- competitive programming file template
    pcall(require, "configs.terms") -- split terminal toggles
end)
