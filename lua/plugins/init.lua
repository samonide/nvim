-- =====================================================================
--  plugins/init.lua
--  Standalone plugin specifications.
--  Theming is owned by Caelestia (colors/caelestia.lua).
--  Grouped logically (core, syntax/LSP, tooling, UI, CP helpers).
-- =====================================================================

return {

    -- ---------------- Core ----------------
    { "nvim-lua/plenary.nvim", lazy = false },

    {
        "nvim-tree/nvim-web-devicons",
        config = function(_, opts)
            require("nvim-web-devicons").setup(opts)
        end,
        opts = {
            override = {
                default_icon = { icon = "󰈚", name = "Default" },
                js = { icon = "󰌞", name = "js" },
                ts = { icon = "󰛦", name = "ts" },
                lock = { icon = "󰌾", name = "lock" },
                ["robots.txt"] = { icon = "󰚩", name = "robots" },
            },
        },
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        event = "User FilePost",
        opts = {
            indent = { char = "│", highlight = "IblIndent" },
            scope = { char = "│", highlight = "IblScope" },
        },
        config = function(_, opts)
            local hooks = require("ibl.hooks")
            hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
            require("ibl").setup(opts)
        end,
    },

    {
        "nvim-tree/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("configs.nvimtree")
        end,
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        cmd = "WhichKey",
        opts = {
            preset = "helix",
            delay = 300,
            expand = 1,
            spec = {
                { "<leader>a", group = "Agent", icon = "" },
                { "<leader>b", group = "Buffer", icon = "󰓩" },
                { "<leader>c", group = "Code / Runner", icon = "󰘐" },
                { "<leader>d", group = "Diagnostics", icon = "󰒡" },
                { "<leader>e", group = "Explorer", icon = "󰙅" },
                { "<leader>f", group = "Find / File", icon = "" },
                { "<leader>g", group = "Git", icon = "" },
                { "<leader>h", group = "Harpoon / Term", icon = "󰛢" },
                { "<leader>l", group = "LSP", icon = "󰒋" },
                { "<leader>q", group = "Quit", icon = "󰗼" },
                { "<leader>s", group = "Split", icon = "󰤼" },
                { "<leader>t", group = "Tools / Trouble", icon = "󰒓" },
                { "<leader>w", group = "Save / Keys", icon = "󰆓" },
                { "<leader>x", group = "Todo / Quickfix", icon = "󰷈" },
            },
        },
        config = function(_, opts)
            require("which-key").setup(opts)
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        event = "User FilePost",
        config = function()
            require("configs.gitsigns")
        end,
    },

    {
        "mason-org/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonUpdate" },
        config = function()
            require("configs.mason")
        end,
    },

    -- Completion engine + sources
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "https://codeberg.org/FelipeLema/cmp-async-path.git",
        },
        config = function()
            require("configs.cmp")
        end,
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        dependencies = { "hrsh7th/nvim-cmp" },
        opts = {
            fast_wrap = {},
            disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
            require("nvim-autopairs").setup(opts)
            -- autopairs <> cmp integration
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },

    -- Statusline (replaces NvChad's built-in bar)
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("configs.lualine")
        end,
    },

    -- Smooth cursor without smear (README recipe)
    {
        "sphamba/smear-cursor.nvim",
        event = "VeryLazy",
        opts = {
            stiffness = 0.5,
            trailing_stiffness = 0.5,
            matrix_pixel_threshold = 0.5,
        },
    },

    -- Breadcrumb winbar (file path + code symbols)
    {
        "Bekaboo/dropbar.nvim",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
        config = function()
            require("dropbar").setup()
        end,
    },

    -- Code outline sidebar
    {
        "stevearc/aerial.nvim",
        cmd = "AerialToggle",
        keys = {
            { "<F6>", "<cmd>AerialToggle!<CR>", desc = "Toggle outline" },
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("aerial").setup()
        end,
    },

    -- Sticky scroll context (current function pinned at top)
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "User FilePost",
        cmd = { "TSContextEnable", "TSContextDisable", "TSContextToggle" },
        config = function()
            require("treesitter-context").setup()
        end,
    },

    -- Syntax highlighting & incremental parsing
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        build = ":TSUpdate",
        config = function()
            require("configs.treesitter")
        end,
    },

    -- LSP client configuration
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("configs.lsp_helpers").defaults()
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
        event = { "BufReadPost", "BufNewFile" },
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
        "echasnovski/mini.starter",
        event = "VimEnter",
        config = function()
            require("configs.starter")
        end,
    },

    -- UI/notifications enhancements (cmdline, LSP popups)
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
        keys = {
            { "<leader>ha", mode = "n" },
            { "<leader>hh", mode = "n" },
            { "<leader>1", mode = "n" },
            { "<leader>2", mode = "n" },
            { "<leader>3", mode = "n" },
            { "<leader>4", mode = "n" },
        },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()
        end,
    },

    -- Telescope (fuzzy finder)
    {
        "nvim-telescope/telescope.nvim",
        event = "VeryLazy",
        config = function()
            require("configs.telescope")
        end,
    },

    -- Telescope fzf native for speed
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
            return vim.fn.executable("make") == 1
        end,
        cmd = "Telescope",
        dependencies = { "telescope.nvim" },
        config = function()
            local ok, telescope = pcall(require, "telescope")
            if ok then
                telescope.load_extension("fzf")
            end
        end,
    },

    -- Timesense for complexity analysis and coding stats
    {
        "samonide/timesense.nvim",
        config = function()
            require("timesense").setup()
        end,
        cmd = "Timesense",
        ft = { "cpp", "c" },
    },

    -- Runner for quick code execution
    {
        "samonide/runner.nvim",
        config = function()
            require("runner").setup({
                -- Build directory for compiled languages
                build_dir = ".build",

                -- Test directory
                test_dir = "tests",

                -- Input/output files
                input_file = "input.txt",
                output_file = "output.txt",

                -- Show execution time after running
                show_time = true,

                -- Clean build artifacts after successful run
                clean_after_run = false,

                -- Terminal configuration
                terminal = {
                    split_height = 15,
                    position = "botright",
                },
            })
        end,
        keys = {
            { "<leader>cr", "<cmd>RunCode<cr>", desc = "Run code" },
            { "<leader>cb", "<cmd>RunBuild<cr>", desc = "Build only" },
            { "<leader>ce", "<cmd>RunLast<cr>", desc = "Run last build" },
            { "<leader>ci", "<cmd>RunWithInput<cr>", desc = "Run with input.txt" },
            { "<leader>ct", "<cmd>RunFloat<cr>", desc = "Run in floating terminal" },
            { "<leader>ctt", "<cmd>RunTests<cr>", desc = "Run all tests" },
            { "<leader>co", "<cmd>RunProfile<cr>", desc = "Cycle optimization profile" },
            { "<leader>cw", "<cmd>RunWatch<cr>", desc = "Toggle watch mode" },
            { "<leader>cx", "<cmd>RunHistory<cr>", desc = "Show run history" },
            { "<leader>cc", "<cmd>RunClean<cr>", desc = "Clean build directory" },
            { "<C-A-n>", "<cmd>RunIOFiles<cr>", desc = "Run with input.txt -> output.txt" },
        },
    },

    -- Floating terminal manager
    {
        "nvzone/floaterm",
        dependencies = { "nvzone/volt" },
        cmd = { "FloatermToggle" },
        keys = {
            {
                "<leader>ft",
                "<cmd>FloatermToggle<cr>",
                mode = { "n", "t" },
                desc = "Toggle floating terminal",
            },
            {
                "<leader>ftn",
                function()
                    -- new_term needs initialized state; open the UI first
                    local floaterm = require("floaterm")
                    if not require("floaterm.state").volt_set then
                        floaterm.open()
                    end
                    require("floaterm.api").new_term()
                end,
                desc = "New floating terminal",
            },
        },
        opts = {
            border = true,
            size = { h = 85, w = 90 },
        },
        config = function(_, opts)
            require("configs.floaterm").setup(opts)
        end,
    },

    -- Trouble diagnostics UI
    {
        "folke/trouble.nvim",
        cmd = { "Trouble", "TroubleToggle" },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
    },

    -- Discord Rich Presence (starts automatically, on by default)
    {
        "vyfor/cord.nvim",
        build = ":Cord update",
        event = "VeryLazy",
        config = function()
            require("cord").setup({
                enabled = true,
                editor = {
                    client = "neovim",
                    tooltip = "The Superior Text Editor",
                },
                display = {
                    theme = "default",
                    flavor = "dark",
                },
                idle = {
                    enabled = true,
                    timeout = 300000, -- 5 minutes
                    show_status = true,
                },
            })
        end,
    },

    -- Surround operations (add/change/delete surrounding pairs)
    {
        "kylechui/nvim-surround",
        version = "*",
        keys = {
            { "ys", mode = "n" },
            { "yss", mode = "n" },
            { "ds", mode = "n" },
            { "cs", mode = "n" },
            { "S", mode = "x" },
        },
        config = function()
            require("nvim-surround").setup({})
        end,
    },

    -- Highlight and navigate TODO comments
    {
        "folke/todo-comments.nvim",
        keys = {
            { "]t", mode = "n" },
            { "[t", mode = "n" },
            { "<leader>xt", mode = "n" },
            { "<leader>xf", mode = "n" },
        },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            signs = true,
            keywords = {
                FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
                TODO = { icon = " ", color = "info" },
                HACK = { icon = " ", color = "warning" },
                WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
                TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
            },
        },
    },

    -- Flash for quick navigation (better than default f/t)
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            modes = {
                char = {
                    jump_labels = true, -- show labels for f/F/t/T
                },
            },
        },
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
        },
    },

    -- Git blame and history viewer
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
        opts = {},
    },

    -- Pi coding agent (pi2.nvim). Requires `pi` CLI in $PATH.
    {
        "zgs225/pi2.nvim",
        dependencies = {
            "MeanderingProgrammer/render-markdown.nvim",
        },
        keys = {
            {
                "<leader>ap",
                function()
                    require("configs.pi").toggle()
                end,
                desc = "Toggle Pi",
            },
            { "<leader>aP", "<Cmd>PiNewTab<CR>", desc = "Pi (new tab)" },
        },
        config = function()
            require("configs.pi").setup()
        end,
    },

    -- Keycast (show pressed keys)
    {
        "nvzone/showkeys",
        lazy = false,
        opts = {
            position = "top-right",
            maxkeys = 3,
            show_count = true,
            winopts = {
                focusable = false,
                relative = "editor",
                style = "minimal",
                border = "single",
                height = 1,
                row = 1,
                col = 0,
            },
        },
        config = function(_, opts)
            require("showkeys").setup(opts)
            vim.schedule(function()
                vim.cmd("ShowkeysToggle")
            end)
        end,
    },

    -- Snippets: LuaSnip + community snippets + custom CP snippet
    {
        "L3MON4D3/LuaSnip",
        event = "InsertEnter",
        config = function()
            require("configs.luasnip")
        end,
    },
    {
        "rafamadriz/friendly-snippets",
        event = "InsertEnter",
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
            local ls = require("luasnip")
            local s = ls.snippet
            local t = ls.text_node
            local i = ls.insert_node
            
            -- Simple C++ boilerplate (trigger: cb)
            ls.add_snippets("cpp", {
                s("cb", {
                    t({
                        "#include <iostream>",
                        "#include <vector>",
                        "#include <string>",
                        "#include <algorithm>",
                        "",
                        "using namespace std;",
                        "",
                        "int main() {",
                        "    ",
                    }),
                    i(1, "// Your code here"),
                    t({
                        "",
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
