-- Treesitter configuration for the new API (no configs module)
require("nvim-treesitter").setup({
    ensure_installed = {
        "bash",
        "c",
        "cpp",
        "fish",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "printf",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
    },
    
    highlight = {
        enable = true,
    },
    
    indent = {
        enable = true,
    },
})
