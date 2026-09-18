-- nvim-lint configuration + autocommands
local lint = require("lint")

lint.linters_by_ft = {
    lua = { "luacheck" },
    -- haskell = { "hlint" },
    -- python = { "flake8" },
}

lint.linters.luacheck.args = {
    "--globals",
    "love",
    "vim",
    "--formatter",
    "plain",
    "--codes",
    "--ranges",
    "-",
}

-- Trigger lint on save and when leaving insert mode
-- (BufEnter intentionally excluded: it fires on split navigation too)
vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("NvimLint", { clear = true }),
    desc = "Run linter",
    callback = function()
        lint.try_lint()
    end,
})
