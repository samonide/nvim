-- Treesitter configuration for the new API (no configs module)
require("nvim-treesitter").setup({
    ensure_installed = {
        "bash",
        -- "c",
        -- "cmake",
        -- "cpp",
        "fish",
        -- "go",
        -- "gomod",
        -- "gosum",
        -- "gotmpl",
        -- "gowork",
        -- "haskell",
        "lua",
        "luadoc",
        -- "make",
        "markdown",
        "markdown_inline",
        -- "odin",
        "printf",
        -- "python",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
    },
    
    highlight = {
        enable = true,
        use_languagetree = true,
    },
    
    indent = {
        enable = true,
    },
})
