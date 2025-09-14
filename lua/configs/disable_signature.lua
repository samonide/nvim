-- Disable LSP signature help popups globally
-- Prevent any UI from showing and stealing focus when typing functions
vim.lsp.handlers["textDocument/signatureHelp"] = function() end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("DisableSignatureHelp", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    if client.server_capabilities then
      client.server_capabilities.signatureHelpProvider = nil
    end
    -- If lsp_signature.nvim is present, try to detach it from this buffer
    local ok, sig = pcall(require, "lsp_signature")
    if ok and sig and type(sig.detach) == "function" then
      pcall(sig.detach, client, args.buf)
    end
  end,
})
