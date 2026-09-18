-- =====================================================================
--  Entry point for this Neovim configuration.
--  Standalone setup (no distribution dependency).
--  Theming is owned by Caelestia (colors/caelestia.lua, applied on VimEnter
--  and live-updated via a watcher on scheme.json).
--  Responsibilities:
--    * Define leader key
--    * Bootstrap lazy.nvim plugin manager
--    * Load plugin specs (lua/plugins) + user options
-- =====================================================================

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

require("configs.autocmds")

-- Caelestia extras (lualine palette source + extra hl groups)
local ok_cael, cael = pcall(require, "configs.caelestia")
if ok_cael then
    cael.setup()
end

-- Defer custom mappings & CP template autocmd so core is initialized
vim.schedule(function()
    require("mappings") -- user + extended keymaps
    pcall(require, "configs.cp_template") -- competitive programming file template
    pcall(require, "configs.terms") -- split terminal toggles
end)
