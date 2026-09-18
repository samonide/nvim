-- Mason-LSPconfig: derive ensure_installed list from servers defined in lspconfig.lua
-- Updated for vim.lsp.config API (Nvim 0.11+)

-- List of servers to ignore during install
local ignore_install = {} -- Add server names you want to skip auto-installing

-- Get servers list from shared module
local servers = require("configs.servers")

-- Build a list of lsp servers to install minus the ignored list.
local all_servers = {}
for _, s in ipairs(servers) do
    if not vim.tbl_contains(ignore_install, s) then
        table.insert(all_servers, s)
    end
end

require("mason-lspconfig").setup({
    ensure_installed = all_servers,
    automatic_installation = false,
})
