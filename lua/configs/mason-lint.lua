-- Mason-nvim-lint integration: auto-install linters defined in lint.linters_by_ft
local lint = package.loaded["lint"]

-- List of linters to ignore during install
local ignore_install = {} -- Add linter names to skip

-- Build a list of linters to install minus the ignored list.
local all_linters = {}
for _, v in pairs(lint.linters_by_ft) do
    for _, linter in ipairs(v) do
        if not vim.tbl_contains(ignore_install, linter) then
            table.insert(all_linters, linter)
        end
    end
end

require("mason-nvim-lint").setup({
    ensure_installed = all_linters,
    automatic_installation = false,
})
