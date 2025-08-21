-- Startup dashboard (alpha.nvim) configuration
local present, alpha = pcall(require, "alpha")
if not present then
  return
end

local dashboard = require("alpha.themes.dashboard")

-- ASCII Header (compact & fast to render)
dashboard.section.header.val = {
  "███╗   ██╗██╗   ██╗ ██████╗██╗  ██╗ █████╗ ██████╗ ",
  "████╗  ██║╚██╗ ██╔╝██╔════╝██║  ██║██╔══██╗██╔══██╗",
  "██╔██╗ ██║ ╚████╔╝ ██║     ███████║███████║██████╔╝",
  "██║╚██╗██║  ╚██╔╝  ██║     ██╔══██║██╔══██║██╔══██╗",
  "██║ ╚████║   ██║   ╚██████╗██║  ██║██║  ██║██║  ██║",
  "╚═╝  ╚═══╝   ╚═╝    ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝",
  "        NvChad Minimal + Competitive Mode        ",
}

local function button(sc, txt, keybind)
  local b = dashboard.button(sc, txt, keybind)
  b.opts.hl = "AlphaButtons"
  b.opts.hl_shortcut = "AlphaShortcut"
  return b
end

-- Buttons
dashboard.section.buttons.val = {
  button("f", "  Find file", ":Telescope find_files<CR>"),
  button("r", "  Recent", ":Telescope oldfiles<CR>"),
  button("g", "  Live grep", ":Telescope live_grep<CR>"),
  button("e", "  New file", ":enew<CR>"),
  button("p", "  Projects", ":Telescope projects<CR>"),
  button("c", "  Config", ":e $MYVIMRC<CR>"),
  button("u", "󰚰  Update Plugins", ":Lazy sync<CR>"),
  button("q", "  Quit", ":qa<CR>"),
}

-- Footer with plugin stats
local function footer()
  local lazy_ok, lazy = pcall(require, "lazy")
  if not lazy_ok then return "" end
  local stats = lazy.stats()
  return string.format(" %d/%d plugins loaded", stats.loaded, stats.count)
end

dashboard.section.footer.val = footer()

-- Layout tweaks
for _, section in pairs({ dashboard.section.header, dashboard.section.buttons, dashboard.section.footer }) do
  section.opts.position = "center"
end

dashboard.opts.opts.noautocmd = true

alpha.setup(dashboard.opts)

-- Only show dashboard if opening without file args
if vim.fn.argc() == 0 and vim.api.nvim_buf_get_name(0) == "" then
  vim.cmd("Alpha")
end
