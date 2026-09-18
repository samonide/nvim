-- =====================================================================
--  configs/autocmds.lua
--  Core autocommands. Vendored from NvChad (nvchad.autocmds).
--  Provides the `User FilePost` event used for deferred plugin loading.
-- =====================================================================

local autocmd = vim.api.nvim_create_autocmd

-- User event that fires after UIEnter + only if a file buffer is present
autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("UserFilePost", { clear = true }),
    callback = function(args)
        local file = vim.api.nvim_buf_get_name(args.buf)
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

        if not vim.g.ui_entered and args.event == "UIEnter" then
            vim.g.ui_entered = true
        end

        if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
            vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
            vim.api.nvim_del_augroup_by_name("UserFilePost")

            vim.schedule(function()
                vim.api.nvim_exec_autocmds("FileType", {})
                if vim.g.editorconfig then
                    require("editorconfig").config(args.buf)
                end
            end)
        end
    end,
})

-- Auto-start treesitter highlighting for every filetype
autocmd("FileType", {
    pattern = "*",
    callback = function()
        pcall(vim.treesitter.start)
    end,
})

-- Flash yanked text
autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    desc = "Flash yanked text",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
    end,
})

-- Restore cursor to last position when reopening a file
autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("LastPlace", { clear = true }),
    desc = "Restore cursor to last known position",
    callback = function(args)
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local lines = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 1 and mark[1] <= lines then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Keep splits proportional when the terminal is resized (tiling WMs)
autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("EqualizeSplits", { clear = true }),
    desc = "Equalize split sizes on resize",
    callback = function()
        vim.cmd("wincmd =")
    end,
})
