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

-- Trigger lint on common editing events
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    callback = function()
        lint.try_lint()
    end,
})
