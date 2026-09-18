-- =====================================================================
--  configs/pi.lua
--  pi2.nvim (pi coding agent) wiring. Toggle helpers + buffer keys
--  adapted from the plugin author's own config (zgs225/dotfiles).
--  Requires the `pi` CLI in $PATH. Verify with :checkhealth pi.
-- =====================================================================

local M = {}

local function get_chat()
    local session = require("pi.sessions.manager").get()
    return session and session.chat or nil
end

local function chat_in_current_tab()
    local chat = get_chat()
    if not chat or not chat:is_visible() then
        return false
    end
    local pwin = chat:prompt_win()
    if not pwin then
        return false
    end
    return vim.api.nvim_win_get_tabpage(pwin) == vim.api.nvim_get_current_tabpage()
end

local function show_pi_here(pi)
    local chat = get_chat()
    if chat then
        chat:set_layout("side")
    else
        pi.show({ layout = "side" })
    end
    pi.focus_chat_prompt()
end

function M.toggle()
    local pi = require("pi")
    if chat_in_current_tab() then
        get_chat():hide()
    else
        show_pi_here(pi)
    end
end

function M.setup()
    require("pi").setup({
        show_thinking = true,
        expand_startup_details = false,
        render = { engine = "render-markdown" },
        sessions_list = { auto_open = true },
        layout = {
            default = "side",
            side = { position = "right", width = 0.38 },
            float = { width = 120, height = 0.85, border = "rounded" },
        },
    })

    vim.api.nvim_create_autocmd("BufWinEnter", {
        group = vim.api.nvim_create_augroup("PiWindowPadding", { clear = true }),
        callback = function()
            local ft = vim.bo.filetype
            if ft == "pi-chat-history" or ft == "pi-chat-prompt" or ft == "pi-chat-attachments" then
                local win = vim.api.nvim_get_current_win()
                vim.schedule(function()
                    if vim.api.nvim_win_is_valid(win) then
                        vim.wo[win].signcolumn = "yes:1"
                    end
                end)
            end
        end,
    })

    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("PiBufferKeys", { clear = true }),
        pattern = { "pi-chat-history", "pi-chat-prompt" },
        callback = function(args)
            local leaders = {
                s = { function() require("pi").resume_session() end, "Pi: resume session" },
                n = { function() require("pi").new_session() end, "Pi: new session" },
                m = { function() require("pi").select_model() end, "Pi: select model" },
                h = { function() require("pi").focus_chat_history() end, "Pi: focus history" },
                p = { function() require("pi").focus_chat_prompt() end, "Pi: focus prompt" },
                t = { function() require("pi").tree() end, "Pi: session tree" },
                c = { "<Cmd>PiNewTab<CR>", "Pi: open in new tab" },
                e = { "<Cmd>PiSessions<CR>", "Pi: toggle sessions bar" },
            }
            for key, spec in pairs(leaders) do
                vim.keymap.set({ "n", "i" }, "<C-g>" .. key, spec[1],
                    { buffer = args.buf, desc = spec[2] })
            end

            local function win_nav(dir)
                if vim.api.nvim_get_mode().mode ~= "n" then
                    vim.cmd("stopinsert")
                end
                vim.cmd("wincmd " .. dir)
            end
            for _, dir in ipairs({ "h", "j", "k", "l" }) do
                vim.keymap.set({ "n", "i" }, "<C-" .. dir .. ">", function()
                    win_nav(dir)
                end, { buffer = args.buf, desc = "Window " .. dir })
            end
        end,
    })
end

return M
