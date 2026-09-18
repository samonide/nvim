-- =====================================================================
--  configs/lsp_helpers.lua
--  Standalone LSP helpers. Vendored from NvChad (nvchad.configs.lspconfig
--  + nvchad.lsp) so the config no longer depends on NvChad.
-- =====================================================================

local M = {}

-- Buffer-local LSP keymaps, applied on every LspAttach
M.on_attach = function(_, bufnr)
    local function opts(desc)
        return { buffer = bufnr, desc = "LSP " .. desc }
    end

    local map = vim.keymap.set
    map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
    map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Add workspace folder"))
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))
    map("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts("List workspace folders"))
    map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Go to type definition"))
    map("n", "<leader>ra", vim.lsp.buf.rename, opts("Rename symbol"))
end

-- Disable semantic tokens (treesitter already handles highlighting)
M.on_init = function(client, _)
    if vim.fn.has("nvim-0.11") ~= 1 then
        if client.supports_method("textDocument/semanticTokens") then
            client.server_capabilities.semanticTokensProvider = nil
        end
    else
        if client:supports_method("textDocument/semanticTokens") then
            client.server_capabilities.semanticTokensProvider = nil
        end
    end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    },
}

-- Merge cmp capabilities when cmp is available
local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
    M.capabilities = vim.tbl_deep_extend("force", M.capabilities, cmp_lsp.default_capabilities())
end

M.diagnostic_config = function()
    local x = vim.diagnostic.severity
    vim.diagnostic.config({
        virtual_text = { prefix = "" },
        signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
        underline = true,
        float = { border = "single" },
    })
end

-- Global LSP defaults (replaces nvchad.configs.lspconfig.defaults())
M.defaults = function()
    pcall(dofile, vim.g.base46_cache .. "lsp")
    M.diagnostic_config()

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(args)
            M.on_attach(nil, args.buf)
        end,
    })

    -- New vim.lsp.config API (Neovim 0.11+)
    vim.lsp.config("*", { capabilities = M.capabilities, on_init = M.on_init })
end

return M
