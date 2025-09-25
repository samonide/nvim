-- Mason-LSPconfig: derive ensure_installed list from global servers table
-- Updated for vim.lsp.config API (Nvim 0.11+)

-- List of servers to ignore during install
local ignore_install = {} -- Add server names you want to skip auto-installing

-- Helper function to find if value is in table.
local function table_contains(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

-- Get servers list from the global variable set in lspconfig.lua
-- Fallback to empty table if not found
local servers = _G.lspconfig_servers or {}

-- Build a list of lsp servers to install minus the ignored list.
local all_servers = {}
for _, s in ipairs(servers) do
    if not table_contains(ignore_install, s) then
        table.insert(all_servers, s)
    end
end

require("mason-lspconfig").setup({
    ensure_installed = all_servers,
    automatic_installation = false,
})
