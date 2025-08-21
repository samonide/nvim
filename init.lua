-- =====================================================================
--  Entry point for this Neovim configuration.
--  Responsibilities:
--    * Define leader key & theme cache path
--    * Bootstrap lazy.nvim plugin manager
--    * Load NvChad base + custom plugin specs (lua/plugins)
--    * Load user options and mappings
-- =====================================================================

vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/" -- NvChad theme cache
vim.g.mapleader = " " -- Space as <leader>

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- Bootstrap lazy.nvim if missing (shallow clone stable branch)
if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- Load plugins (NvChad core + user additions in lua/plugins)
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },

  { import = "plugins" },
}, lazy_config)

-- Load cached base46 theme highlights & statusline provided by NvChad
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"

-- Defer custom mappings & CP template autocmd so core is initialized
vim.schedule(function()
  require "mappings"            -- user + extended keymaps
  pcall(require, "configs.cp_template") -- competitive programming file template
end)
