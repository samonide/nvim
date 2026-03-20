local present, starter = pcall(require, "mini.starter")
if not present then
  return
end

local header_art = [[
  _   _                      _
 | \ | | ___  _____   _(_)_ __ ___
 |  \| |/ _ \/ _ \ \ / / | '_ ` _ \
 | |\  |  __/ (_) \ V /| | | | | | |
 |_| \_|\___|\___/ \_/ |_|_| |_| |_|
]]

starter.setup({
  evaluate_single = true,
  items = {
    { name = "f  Find file",       action = "Telescope find_files", section = "" },
    { name = "r  Recent files",    action = "Telescope oldfiles",   section = "" },
    { name = "g  Live grep",       action = "Telescope live_grep",  section = "" },
    { name = "e  New file",        action = "enew",                 section = "" },
    { name = "p  Projects",        action = "Telescope projects",   section = "" },
    { name = "c  Config",          action = "e $MYVIMRC",           section = "" },
    { name = "u  Update plugins",  action = "Lazy sync",            section = "" },
    { name = "q  Quit",            action = "qa",                   section = "" },
  },
  content_hooks = {
    starter.gen_hook.adding_bullet("  "),
    starter.gen_hook.aligning("center", "center"),
  },
  header = header_art,
  footer = function()
    local lazy_ok, lazy_stats = pcall(require, "lazy")
    if lazy_ok then
      local stats = lazy_stats.stats()
      return string.format(" %d/%d plugins loaded", stats.loaded or 0, stats.count or 0)
    end
    return ""
  end,
  -- Remove 'j' and 'k' from query_updaters so they don't jump to items
  query_updaters = "abcdefghilmnopqrstuvwxyz0123456789_-.",
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniStarterOpened",
  callback = function()
    -- Map j and k to move down and up
    local map = function(lhs, rhs)
      vim.keymap.set("n", lhs, rhs, { buffer = true, silent = true })
    end
    map("j", function() require("mini.starter").update_current_item("next") end)
    map("k", function() require("mini.starter").update_current_item("prev") end)
  end,
})

-- Only show starter if opening without file args
if vim.fn.argc() == 0 and vim.api.nvim_buf_get_name(0) == "" then
  vim.defer_fn(function()
    starter.open()
  end, 0)
end
