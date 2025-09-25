-- =====================================================================
--  configs/lspconfig.lua
--  Custom LSP server configurations using vim.lsp.config (Nvim 0.11+)
--  Migrated from legacy lspconfig to new vim.lsp.config API.
--  Adjust server list & per-server settings here.
-- =====================================================================

local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

-- list of all servers configured.
-- Master list of desired servers (Mason installer consumes this via mason-lspconfig)
-- Note: This is now a module-level table since we're not using lspconfig object
local servers = {
    "lua_ls",
    -- "clangd",
    -- "gopls",
    -- "hls",
    -- "ols",
    -- "pyright",
}

-- Export servers list for mason-lspconfig compatibility
-- This maintains compatibility with your existing mason setup
_G.lspconfig_servers = servers

-- list of servers configured with default config.
-- Servers using default setup (loop below)
local default_servers = {
    -- "ols",
    -- "pyright",
}

-- Configure servers with default config using vim.lsp.config
for _, lsp in ipairs(default_servers) do
    vim.lsp.config(lsp, {
        on_attach = on_attach,
        on_init = on_init,
        capabilities = capabilities,
    })
    vim.lsp.enable(lsp)
end

-- Example server configurations using vim.lsp.config (commented for reference)
-- Uncomment and modify as needed

-- vim.lsp.config('clangd', {
--     on_attach = function(client, bufnr)
--         client.server_capabilities.documentFormattingProvider = false
--         client.server_capabilities.documentRangeFormattingProvider = false
--         on_attach(client, bufnr)
--     end,
--     on_init = on_init,
--     capabilities = capabilities,
-- })
-- vim.lsp.enable('clangd')

-- vim.lsp.config('gopls', {
--     on_attach = function(client, bufnr)
--         client.server_capabilities.documentFormattingProvider = false
--         client.server_capabilities.documentRangeFormattingProvider = false
--         on_attach(client, bufnr)
--     end,
--     on_init = on_init,
--     capabilities = capabilities,
--     cmd = { "gopls" },
--     filetypes = { "go", "gomod", "gotmpl", "gowork" },
--     root_dir = function(fname)
--         local util = require('lspconfig.util')
--         return util.root_pattern("go.work", "go.mod", ".git")(fname)
--     end,
--     settings = {
--         gopls = {
--             analyses = {
--                 unusedparams = true,
--             },
--             completeUnimported = true,
--             usePlaceholders = true,
--             staticcheck = true,
--         },
--     },
-- })
-- vim.lsp.enable('gopls')

-- vim.lsp.config('hls', {
--     on_attach = function(client, bufnr)
--         client.server_capabilities.documentFormattingProvider = false
--         client.server_capabilities.documentRangeFormattingProvider = false
--         on_attach(client, bufnr)
--     end,
--     on_init = on_init,
--     capabilities = capabilities,
-- })
-- vim.lsp.enable('hls')

-- lua_ls customized (diagnostics disabled; can re-enable if desired)
vim.lsp.config('lua_ls', {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                enable = false, -- Disable all diagnostics from lua_ls
                -- globals = { "vim" },
            },
            workspace = {
                library = {
                    vim.fn.expand("$VIMRUNTIME/lua"),
                    vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                    vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
                    vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                    "${3rd}/love2d/library",
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
        },
    },
})
vim.lsp.enable('lua_ls')
