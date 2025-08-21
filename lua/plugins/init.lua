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

    -- Notifications (configure before noice so it reuses settings)
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        config = function()
            local ok, notify = pcall(require, "notify")
            if not ok then return end
            notify.setup({
                background_colour = "#1e2030", -- solid base behind transparent theme (adjust if you change colorscheme)
                stages = "fade_in_slide_out",
                timeout = 2000,
                render = "compact",
                top_down = false,
            })
            vim.notify = notify -- route vim.notify through nvim-notify
        end,
    },

    -- UI/notifications enhancements (cmdline, LSP popups) via noice reusing nvim-notify
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
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
                    bottom_search = true,        -- keep search at bottom
                    command_palette = false,     -- disable so we can center cmdline popup
                    long_message_to_split = true,
                    inc_rename = false,
                    lsp_doc_border = true,
                },
                views = {
                    cmdline_popup = {
                        position = { row = "50%", col = "50%" }, -- center of screen
                        size = { width = 60, height = "auto" },
                        border = { style = "rounded", padding = { 0, 1 } },
                        win_options = {
                            winhighlight = "Normal:NormalFloat,FloatBorder:NoiceCmdlinePopupBorder", -- ensure border group used
                        },
                    },
                },
                cmdline = {
                    format = {
                        cmdline = { pattern = "^:", icon = "", lang = "vim" },
                    },
                },
            })

            -- Dynamic border coloring for valid/invalid Ex commands
            local hl = vim.api.nvim_get_hl(0, { name = 'NoiceCmdlinePopupBorder', link = false }) or {}
            local default_border = { fg = hl.fg, bg = hl.bg }

            local function set_border(color_fg)
                vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorder', { fg = color_fg, bg = default_border.bg })
            end

            local function reset_border()
                vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorder', default_border)
            end

            vim.api.nvim_create_autocmd({ 'CmdlineLeave', 'CmdlineEnter' }, {
                callback = reset_border,
            })

            vim.api.nvim_create_autocmd('CmdlineChanged', {
                callback = function()
                    local line = vim.fn.getcmdline()
                    if not line:match('^:') then
                        reset_border()
                        return
                    end
                    local cmd = line:sub(2):match('^(%S+)') -- first word after ':'
                    if not cmd or cmd == '' then
                        reset_border()
                        return
                    end
                    local exists = vim.fn.exists(':' .. cmd) == 2
                    if exists then
                        set_border('#37d99e') -- green
                    else
                        set_border('#e86671') -- red
                    end
                end,
            })

            -- Reapply default on colorscheme change to retain dynamic logic
            vim.api.nvim_create_autocmd('ColorScheme', { callback = function()
                local hl2 = vim.api.nvim_get_hl(0, { name = 'NoiceCmdlinePopupBorder', link = false }) or {}
                default_border.fg = hl2.fg or default_border.fg
                default_border.bg = hl2.bg or default_border.bg
                reset_border()
            end })
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
            -- Load extended CP snippets (dsu, bit, modops, etc.)
            pcall(require, "configs.cp_snippets")
        end,
    },
}
