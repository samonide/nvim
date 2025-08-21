-- =====================================================================
--  plugins/init.lua
--  Additional plugin specifications layered on top of NvChad core.
--  Grouped logically (syntax/LSP, tooling, UI, CP helpers, snippets).
-- =====================================================================

return {

    -- Syntax highlighting & incremental parsing
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.treesitter")
        end,
    },

    -- LSP client configuration
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("nvchad.configs.lspconfig").defaults()
            require("configs.lspconfig")
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lspconfig" },
        config = function()
            require("configs.mason-lspconfig")
        end,
    },

    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.lint")
        end,
    },

    {
        "rshkarin/mason-nvim-lint",
        event = "VeryLazy",
        dependencies = { "nvim-lint" },
        config = function()
            require("configs.mason-lint")
        end,
    },

    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        config = function()
            require("configs.conform")
        end,
    },

    {
        "zapling/mason-conform.nvim",
        event = "VeryLazy",
        dependencies = { "conform.nvim" },
        config = function()
            require("configs.mason-conform")
        end,
    },

    -- Dashboard (welcome screen)
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("configs.alpha")
        end,
    },

    -- UI/notifications & LSP message enhancements
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require("noice").setup({
                lsp = {
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                presets = {
                    bottom_search = true,
                    command_palette = true,
                    long_message_to_split = true,
                    inc_rename = false,
                    lsp_doc_border = true,
                },
            })
        end,
    },

    -- Harpoon for fast file/nav marking
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "VeryLazy",
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()
        end,
    },

    -- Telescope fzf native for speed
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
            return vim.fn.executable("make") == 1
        end,
        event = "VeryLazy",
        config = function()
            local ok, telescope = pcall(require, "telescope")
            if ok then
                telescope.load_extension("fzf")
            end
        end,
    },

    -- Overseer for task management (compile/run/test)
    {
        "stevearc/overseer.nvim",
        event = "VeryLazy",
        config = function()
            require("overseer").setup({
                task_list = { direction = "bottom", min_height = 8, max_height = 20 },
            })
        end,
    },

    -- Trouble diagnostics UI
    {
        "folke/trouble.nvim",
        cmd = { "Trouble", "TroubleToggle" },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
    },

    -- Snippets: LuaSnip + community snippets + custom CP snippet
    { "L3MON4D3/LuaSnip", event = "InsertEnter" },
    {
        "rafamadriz/friendly-snippets",
        event = "InsertEnter",
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
            local ls = require("luasnip")
            local s = ls.snippet
            local t = ls.text_node
            local i = ls.insert_node
            -- Custom C++ competitive template snippet (trigger: cp)
            ls.add_snippets("cpp", {
                s("cp", {
                    t({
                        "#include <bits/stdc++.h>",
                        "using namespace std;",
                        "",
                        "#define fast_io ios::sync_with_stdio(false); cin.tie(nullptr);",
                        "#define all(x) (x).begin(), (x).end()",
                        "#define sz(x) (int)(x).size()",
                        "using ll = long long;",
                        "",
                        "int main() {",
                        "    fast_io;",
                        "    int T = 1;",
                        "    // cin >> T;",
                        "    while (T--) {",
                        "        ",
                        "    }",
                        "    return 0;",
                        "}",
                    }),
                }),
            })
        end,
    },
}
