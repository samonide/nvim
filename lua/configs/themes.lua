-- =====================================================================
--  configs/themes.lua
--  Theme switcher. Replaces NvChad's theme picker (<leader>th).
--  Lists all base46 themes in a Telescope picker, live-applies on
--  selection, and persists the choice to lua/nvconfig.lua.
-- =====================================================================

local M = {}

local config_path = vim.fn.stdpath("config") .. "/lua/nvconfig.lua"

-- All base46 theme names (from the base46 repo + user overrides)
function M.list_themes()
    local themes = {}
    local seen = {}

    local function scan(path)
        local handle = vim.uv.fs_scandir(path)
        if not handle then
            return
        end
        while true do
            local name, typ = vim.uv.fs_scandir_next(handle)
            if not name then
                break
            end
            if typ == "file" and name:sub(-4) == ".lua" then
                local t = name:sub(1, -5)
                if not seen[t] then
                    seen[t] = true
                    table.insert(themes, t)
                end
            end
        end
    end

    scan(vim.fn.stdpath("data") .. "/lazy/base46/lua/base46/themes")
    table.sort(themes)
    return themes
end

-- Apply theme now: update nvconfig table, recompile + reload highlights
function M.apply(theme)
    local ok, nvconfig = pcall(require, "nvconfig")
    if not ok then
        vim.notify("nvconfig.lua not found", vim.log.levels.ERROR)
        return
    end
    nvconfig.base46.theme = theme
    require("base46").load_all_highlights()
end

-- Persist theme choice to lua/nvconfig.lua
local function persist(theme)
    local lines = {}
    local f = io.open(config_path, "r")
    if not f then
        return false
    end
    for line in f:lines() do
        table.insert(lines, line)
    end
    f:close()

    local done = false
    for i, line in ipairs(lines) do
        if not done and line:match('^%s*theme%s*=%s*"') then
            lines[i] = line:gsub('theme%s*=%s*"[^"]*"', 'theme = "' .. theme .. '"', 1)
            done = true
        end
    end
    if not done then
        return false
    end

    f = io.open(config_path, "w")
    if not f then
        return false
    end
    f:write(table.concat(lines, "\n") .. "\n")
    f:close()
    return true
end

-- Telescope picker (<leader>th)
function M.open()
    local ok, pickers = pcall(require, "telescope.pickers")
    if not ok then
        vim.notify("telescope not available", vim.log.levels.ERROR)
        return
    end
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    local current = require("nvconfig").base46.theme

    pickers
        .new({}, {
            prompt_title = "Themes (current: " .. current .. ")",
            finder = finders.new_table({ results = M.list_themes() }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(bufnr)
                actions.select_default:replace(function()
                    actions.close(bufnr)
                    local theme = action_state.get_selected_entry()[1]
                    M.apply(theme)
                    if persist(theme) then
                        vim.notify("Theme: " .. theme, vim.log.levels.INFO)
                    else
                        vim.notify("Theme applied (not persisted): " .. theme, vim.log.levels.WARN)
                    end
                end)
                return true
            end,
        })
        :find()
end

-- Toggle transparency + persist
function M.toggle_transparency()
    local nvconfig = require("nvconfig")
    nvconfig.base46.transparency = not nvconfig.base46.transparency
    require("base46").load_all_highlights()

    local lines = {}
    local f = io.open(config_path, "r")
    if f then
        for line in f:lines() do
            table.insert(lines, line)
        end
        f:close()
        for i, line in ipairs(lines) do
            if line:match("^%s*transparency%s*=") then
                lines[i] = line:gsub(
                    "transparency%s*=%s*%a+",
                    "transparency = " .. tostring(nvconfig.base46.transparency),
                    1
                )
                break
            end
        end
        f = io.open(config_path, "w")
        if f then
            f:write(table.concat(lines, "\n") .. "\n")
            f:close()
        end
    end

    vim.notify(
        "Transparency: " .. (nvconfig.base46.transparency and "on" or "off"),
        vim.log.levels.INFO
    )
end

return M
