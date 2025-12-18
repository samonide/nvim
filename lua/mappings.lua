-- =====================================================================
--  mappings.lua
--  Extends NvChad default mappings. All custom keymaps are declared with
--  descriptive `desc` for WhichKey & cheatsheet visibility.
--  Sections:
--    * Core quality-of-life
--    * Competitive Programming helpers
--    * Harpoon, Trouble, Overseer, Snippets
-- =====================================================================

require "nvchad.mappings" -- load NvChad defaults first
pcall(require, "configs.disable_signature") -- ensure signature popups are disabled early

-- Always enable line numbers + relative numbers on startup
vim.opt.number = true
vim.opt.relativenumber = true

-- Hide numbers in dashboard-like buffers (robust across UIs)
local hidegrp = vim.api.nvim_create_augroup("HideNumbersOnDashboard", { clear = true })
local function hide_nums()
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
  vim.opt_local.signcolumn = "no"
  vim.opt_local.cursorline = false
end
vim.api.nvim_create_autocmd("FileType", {
  group = hidegrp,
  pattern = { "alpha", "dashboard", "nvdash", "starter" },
  callback = hide_nums,
})
vim.api.nvim_create_autocmd("User", {
  group = hidegrp,
  pattern = { "AlphaReady", "NvDashReady" },
  callback = hide_nums,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = hidegrp,
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if ft == "alpha" or ft == "dashboard" or ft == "nvdash" or ft == "starter" then
      hide_nums()
    end
  end,
})

-- Unmap any default Alt-i to reuse as our floating terminal toggle
pcall(vim.keymap.del, 'n', '<A-i>')
pcall(vim.keymap.del, 't', '<A-i>')

local map = vim.keymap.set

-- ---------- Core QoL --------------------------------------------------
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert (jk)" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>") -- Uncomment for Ctrl+S save

-- =====================================================
-- Competitive Programming: C / C++ build & run helpers
-- =====================================================
-- Functions compile current file (if cpp or c) into a temp/ project local bin
-- and open / reuse a terminal (simple split + termopen) to run it interactively.
-- We avoid nvchad.term here because its API returned nil in some setups; a
-- lightweight custom terminal ensures the binary starts AND waits for input.

-- Open a bottom split terminal running a command, reusing buffer variable
local function open_cp_term(cmd)
	-- Always create a fresh terminal (simpler & avoids job conflicts)
	vim.cmd("botright 15split")
	vim.cmd("enew")
	local buf = vim.api.nvim_get_current_buf()
	
	-- Run command directly without any wrapper
	vim.fn.termopen(cmd)
	vim.cmd("startinsert")
	vim.g.cp_term_buf = buf
end

-- Floating bash terminal manager (toggle + fresh-run helper)
local function make_float_win(buf)
	local width = math.floor(vim.o.columns * 0.9)
	local height = math.floor(vim.o.lines * 0.85)
	return vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
	})
end

-- Toggle a single shared floating bash terminal (no rc/history)
local function toggle_floating_bash()
	local win = vim.g._float_bash_win
	local buf = vim.g._float_bash_buf
	if win and vim.api.nvim_win_is_valid(win) then
		pcall(vim.api.nvim_win_close, win, true)
		vim.g._float_bash_win = nil
		return
	end
	if buf and vim.api.nvim_buf_is_valid(buf) then
		vim.g._float_bash_win = make_float_win(buf)
		vim.cmd('startinsert')
		return
	end
	buf = vim.api.nvim_create_buf(false, true)
	vim.g._float_bash_buf = buf
	vim.g._float_bash_win = make_float_win(buf)
	vim.fn.termopen({ 'bash', '--noprofile' })
	vim.cmd('startinsert')
end

-- Open a brand-new floating bash and run a command (no rc/history)
local function open_fresh_floating_bash(cmd)
	local buf = vim.api.nvim_create_buf(false, true)
	local win = make_float_win(buf)
	if type(cmd) == 'string' and #cmd > 0 then
		vim.fn.termopen({ 'bash', '--noprofile', '-lc', cmd })
	elseif type(cmd) == 'table' then
		vim.fn.termopen(cmd)
	else
		vim.fn.termopen({ 'bash', '--noprofile' })
	end
	vim.cmd('startinsert')
	return buf, win
end

-- Build profiles and generic compile helper (can run or just build)
local opt_profiles = {
	{ name = 'O2',    cpp = '-std=c++17 -O2 -Wall -Wextra -Wshadow -pedantic', c = '-O2 -Wall -Wextra -pedantic' },
	{ name = 'Ofast', cpp = '-std=c++17 -Ofast -march=native -DNDEBUG -Wall -Wextra -Wshadow', c = '-Ofast -march=native -DNDEBUG -Wall -Wextra' },
}
local current_profile = 1

local function compile_cpp(opts)
	opts = opts or {}
	local run_after = opts.run ~= false
	local on_success = opts.on_success

	local ft = vim.bo.filetype
	if ft ~= 'cpp' and ft ~= 'c' then
		vim.notify('Not a C/C++ file', vim.log.levels.WARN)
		return
	end

	local filename = vim.fn.expand('%:t')
	local filepath = vim.fn.expand('%:p')
	local base = vim.fn.expand('%:t:r')
	local outdir = vim.fn.getcwd() .. '/.build'
	vim.fn.mkdir(outdir, 'p')
	local bin = outdir .. '/' .. base

	local profile = opt_profiles[current_profile]
	local flags = ft == 'cpp' and profile.cpp or profile.c
	local compiler = ft == 'cpp' and 'g++' or 'gcc'
	local cmd = string.format('%s %s "%s" -o "%s"', compiler, flags, filepath, bin)

	vim.notify(string.format('Compiling (%s): %s', profile.name, filename), vim.log.levels.INFO)
	vim.fn.jobstart(cmd, {
		stdout_buffered = true,
		stderr_buffered = true,
		on_exit = function(_, code)
			if code == 0 then
				if run_after then
					vim.notify('Build success → running', vim.log.levels.INFO)
					open_cp_term(bin)
				else
					vim.notify('Build success', vim.log.levels.INFO)
					if on_success then on_success(bin) end
				end
			else
				vim.notify('Build failed (code ' .. code .. ')', vim.log.levels.ERROR)
			end
		end,
	})
end

local function build_and_run_cpp()
	compile_cpp({ run = true })
end

-- Execute last built artifact without rebuilding
local function run_only()
	local ft = vim.bo.filetype
	if ft ~= 'cpp' and ft ~= 'c' then
		vim.notify('Not a C/C++ file', vim.log.levels.WARN)
		return
	end
	local base = vim.fn.expand('%:t:r')
	local output = vim.fn.getcwd() .. '/.build/' .. base
	if vim.fn.filereadable(output) == 0 then
		vim.notify('Binary not found. Build first (<leader>cr)', vim.log.levels.WARN)
		return
	end
	open_cp_term(output)
end

map('n', '<leader>cr', build_and_run_cpp, { desc = 'C/C++ Compile & Run (profile flags)' })
map('n', '<leader>cb', build_and_run_cpp, { desc = 'C/C++ Build alias' })
map('n', '<leader>ce', run_only, { desc = 'C/C++ Execute last build' })

-- Create input.txt and run program with it (shows output in terminal)
map('n', '<leader>ci', function()
	local ft = vim.bo.filetype
	if ft ~= 'cpp' and ft ~= 'c' then
		vim.notify('Not a C/C++ file', vim.log.levels.WARN)
		return
	end

	local input_file = 'input.txt'
	-- Ensure file is saved before building
	pcall(vim.cmd, 'write')

	-- Create input.txt if it doesn't exist
	if vim.fn.filereadable(input_file) == 0 then
		vim.fn.writefile({''}, input_file)
		vim.notify('Created empty input.txt', vim.log.levels.INFO)
	end

	-- Always rebuild, then run with input.txt in a fresh bottom terminal
	compile_cpp({
		run = false,
		on_success = function(new_bin)
			open_cp_term(string.format('%s < %s', new_bin, input_file))
		end,
	})
end, { desc = 'Run C++ with input.txt in terminal' })

-- Build and run C++ in floating terminal
map('n', '<leader>ct', function()
	local ft = vim.bo.filetype
	if ft ~= 'cpp' and ft ~= 'c' then
		vim.notify('Not a C/C++ file', vim.log.levels.WARN)
		return
	end
	pcall(vim.cmd, 'write')
	compile_cpp({
		run = false,
		on_success = function(bin)
			-- Run inside a brand-new floating bash so there is no history
			open_fresh_floating_bash(bin)
		end,
	})
end, { desc = 'Build & run C++ in floating terminal' })

-- =============================================
-- Harpoon (file marks) - requires harpoon2
-- =============================================
map('n', '<leader>ha', function()
	require('harpoon'):list():add()
	vim.notify('Added to Harpoon list')
end, { desc = 'Harpoon add file' })
map('n', '<leader>hm', function()
	require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())
end, { desc = 'Harpoon menu' })
for i = 1, 4 do
	map('n', string.format('<leader>h%d', i), function()
		require('harpoon'):list():select(i)
	end, { desc = 'Harpoon select #' .. i })
end

-- =============================================
-- Trouble diagnostics quick toggles
-- =============================================
map('n', '<leader>td', '<cmd>Trouble diagnostics toggle focus=true<CR>', { desc = 'Trouble diagnostics' })
map('n', '<leader>tq', '<cmd>Trouble qflist toggle<CR>', { desc = 'Trouble quickfix' })
map('n', '<leader>tr', '<cmd>Trouble lsp_references toggle focus=true<CR>', { desc = 'Trouble references' })

-- =============================================
-- Overseer tasks (compile / run orchestrator)
-- =============================================
map('n', '<leader>ot', '<cmd>OverseerToggle<CR>', { desc = 'Overseer task list' })
map('n', '<leader>or', '<cmd>OverseerRun<CR>', { desc = 'Overseer run task' })

-- =============================================
-- Simple multi-test harness for C++ (tests/1.in 1.out ...) — lightweight alternative to full task config
-- =============================================
local function run_all_tests()
	local ft = vim.bo.filetype
	if ft ~= 'cpp' and ft ~= 'c' then
		vim.notify('Not a C/C++ file', vim.log.levels.WARN)
		return
	end

	local function run_tests(bin)
		local test_dir = 'tests'
		if vim.fn.isdirectory(test_dir) == 0 then
			vim.notify('No tests/ directory', vim.log.levels.WARN)
			return
		end
		local inputs = vim.fn.globpath(test_dir, '*.in', false, true)
		if #inputs == 0 then
			vim.notify('No *.in test files', vim.log.levels.WARN)
			return
		end
		local passed, total = 0, #inputs
		local results = {}
		for _, infile in ipairs(inputs) do
			local stem = infile:match('(.+)%%.in$') or infile
			local expected_file = stem .. '.out'
			local actual = vim.fn.system(string.format('%s < %s', bin, infile))
			local expected = ''
			local has_expected = vim.fn.filereadable(expected_file) == 1
			if has_expected then
				expected = table.concat(vim.fn.readfile(expected_file), '\n') .. '\n'
			end
			if has_expected and actual == expected then
				passed = passed + 1
				table.insert(results, '✓ ' .. infile .. ' PASS')
			elseif has_expected then
				table.insert(results, '✗ ' .. infile .. ' FAIL')
				table.insert(results, '  expected: ' .. expected:gsub('\n$', ''))
				table.insert(results, '  actual  : ' .. actual:gsub('\n$', ''))
			else
				table.insert(results, '… ' .. infile .. ' (no expected .out file)')
			end
		end
		table.insert(results, string.format('Result: %d/%d passed', passed, total))
		vim.notify(table.concat(results, '\n'), passed == total and vim.log.levels.INFO or vim.log.levels.WARN, { title = 'Test Summary' })
	end

	local base = vim.fn.expand('%:t:r')
	local bin = vim.fn.getcwd() .. '/.build/' .. base
	if vim.fn.filereadable(bin) == 0 then
		vim.notify('Binary not built. Building now...', vim.log.levels.INFO)
		compile_cpp({ run = false, on_success = run_tests })
		return
	end
	local test_dir = 'tests'
	if vim.fn.isdirectory(test_dir) == 0 then
		vim.notify('No tests/ directory', vim.log.levels.WARN)
		return
	end
	local inputs = vim.fn.globpath(test_dir, '*.in', false, true)
	if #inputs == 0 then
		vim.notify('No *.in test files', vim.log.levels.WARN)
		return
	end
	local passed, total = 0, #inputs
	local results = {}
	for _, infile in ipairs(inputs) do
		local stem = infile:match('(.+)%.in$') or infile
		local expected_file = stem .. '.out'
		local actual = vim.fn.system(string.format('%s < %s', bin, infile))
		local expected = ''
		local has_expected = vim.fn.filereadable(expected_file) == 1
		if has_expected then
			expected = table.concat(vim.fn.readfile(expected_file), '\n') .. '\n'
		end
		if has_expected and actual == expected then
			passed = passed + 1
			table.insert(results, '✓ ' .. infile .. ' PASS')
		elseif has_expected then
			table.insert(results, '✗ ' .. infile .. ' FAIL')
			table.insert(results, '  expected: ' .. expected:gsub('\n$', ''))
			table.insert(results, '  actual  : ' .. actual:gsub('\n$', ''))
		else
			table.insert(results, '… ' .. infile .. ' (no expected .out file)')
		end
	end
	table.insert(results, string.format('Result: %d/%d passed', passed, total))
	vim.notify(table.concat(results, '\n'), passed == total and vim.log.levels.INFO or vim.log.levels.WARN, { title = 'Test Summary' })
end
map('n', '<leader>ctt', run_all_tests, { desc = 'Run all tests in tests/*.in' })

-- =============================================
-- Run with input.txt -> output.txt (Ctrl+Alt+n)
-- =============================================
local function run_with_io_files()
	local ft = vim.bo.filetype
	if ft ~= 'cpp' and ft ~= 'c' then
		vim.notify('Not a C/C++ file', vim.log.levels.WARN)
		return
	end
	local base = vim.fn.expand('%:t:r')
	local bin = vim.fn.getcwd() .. '/.build/' .. base
	local input_file = 'input.txt'
	local output_file = 'output.txt'
	
	-- Create input.txt if it doesn't exist
	if vim.fn.filereadable(input_file) == 0 then
		vim.fn.writefile({''}, input_file)
		vim.notify('Created empty input.txt', vim.log.levels.INFO)
	end
	
	-- Check if binary exists, build if not (compile only, no run)
	if vim.fn.filereadable(bin) == 0 then
		vim.notify('Binary not found. Building first...', vim.log.levels.INFO)
		compile_cpp({
			run = false,
			on_success = function(new_bin)
				local cmd2 = string.format('%s < %s > %s', new_bin, input_file, output_file)
				vim.fn.system(cmd2)
				vim.notify('Output written to output.txt', vim.log.levels.INFO)
			end,
		})
		return
	end
	
	-- Run with input/output redirection
	local cmd = string.format('%s < %s > %s', bin, input_file, output_file)
	local result = vim.fn.system(cmd)
	local exit_code = vim.v.shell_error
	
	if exit_code == 0 then
		vim.notify('Success! Output written to output.txt', vim.log.levels.INFO)
	else
		vim.notify('Runtime error (code ' .. exit_code .. ')', vim.log.levels.ERROR)
	end
end

map('n', '<C-A-n>', run_with_io_files, { desc = 'Run C++ with input.txt -> output.txt' })

-- =============================================
-- Optimization profile toggle for C++
-- =============================================
local function cycle_profile()
	current_profile = current_profile % #opt_profiles + 1
	vim.g.cpp_opt_profile = opt_profiles[current_profile].name
	vim.notify('Profile: ' .. opt_profiles[current_profile].name)
end
map('n', '<leader>co', cycle_profile, { desc = 'Cycle C++ optimization profile' })

-- Toggle shell between zsh and fish (Neovim internal terminal only)
map('n', '<leader>ts', function()
	local current = vim.o.shell
	local zsh = (vim.fn.executable('/usr/bin/zsh') == 1 and '/usr/bin/zsh') or (vim.fn.executable('/bin/zsh') == 1 and '/bin/zsh')
	local fish = (vim.fn.executable('/usr/bin/fish') == 1 and '/usr/bin/fish') or (vim.fn.executable('/bin/fish') == 1 and '/bin/fish')
	if current == zsh and fish then
		vim.o.shell = fish
		vim.notify('Shell set to fish (Neovim only)')
	elseif zsh then
		vim.o.shell = zsh
		vim.notify('Shell set to zsh (Neovim only)')
	else
		vim.notify('No zsh found; shell unchanged', vim.log.levels.WARN)
	end
end, { desc = 'Toggle shell zsh<->fish (nvim term)' })

-- Override build function to inject active optimization profile flags
-- Old override removed; compile_cpp now handles profiles and running

-- =============================================
-- Additional terminal toggle
-- =============================================
map('n', '<leader>ft', function()
  -- Toggle a shared floating bash terminal (identical to Alt-i)
  toggle_floating_bash()
end, { desc = 'Toggle floating bash terminal' })

-- Alt-i should behave exactly like <leader>ft (toggle open/close)
map({ 'n', 't' }, '<A-i>', function()
  toggle_floating_bash()
end, { desc = 'Toggle floating bash terminal' })

-- =============================================
-- LuaSnip navigation (if using luasnip)
-- =============================================
map({ 'i', 's' }, '<C-j>', function()
	if ls.expand_or_jumpable() then ls.expand_or_jump() end
end, { desc = 'LuaSnip expand or jump forward' })
map({ 'i', 's' }, '<C-k>', function()
	if ls.jumpable(-1) then ls.jump(-1) end
end, { desc = 'LuaSnip jump backward' })

-- =============================================
-- Terminal toggle (Alt-h / Alt-v) and leader h/v for window navigation
-- =============================================

-- Repurpose leader h/v to navigate splits
map('n', '<leader>h', '<C-w>h', { desc = 'Focus left split' })
map('n', '<leader>v', '<C-w>l', { desc = 'Focus right split' })

-- Horizontal terminal toggle (Alt-h) and Vertical (Alt-v)
local function toggle_term(dir)
	local buf = vim.g.toggle_term_buf
	local buf_valid = buf and vim.api.nvim_buf_is_valid(buf)
	local win_with_buf
	if buf_valid then
		for _, w in ipairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_get_buf(w) == buf then
				win_with_buf = w
				break
			end
		end
	end

	-- If buffer is currently shown -> close the window (toggle off)
	if buf_valid and win_with_buf then
		pcall(vim.api.nvim_win_close, win_with_buf, true)
		return
	end

		-- If buffer exists but not shown -> show it (direction respected)
		if buf_valid then
			if dir == 'v' then vim.cmd('botright vsplit') else vim.cmd('botright 15split') end
			vim.api.nvim_set_current_buf(buf)
			vim.cmd('startinsert')
			return
		end

		-- Create new terminal buffer (use bash without rc to avoid neofetch/history)
		if dir == 'v' then vim.cmd('botright vsplit') else vim.cmd('botright 15split') end
	vim.cmd('enew')
	local new_buf = vim.api.nvim_get_current_buf()
	vim.fn.termopen({ 'bash', '--noprofile'})
	vim.g.toggle_term_buf = new_buf
	vim.cmd('startinsert')
end
	map('n', '<A-h>', function() toggle_term('h') end, { desc = 'Toggle horizontal terminal' })
	map('n', '<A-v>', function() toggle_term('v') end, { desc = 'Toggle vertical terminal' })

-- =============================================
-- Additional Productivity Keymaps
-- =============================================

-- Better movement in wrapped lines
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = 'Move down (wrap-aware)' })
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = 'Move up (wrap-aware)' })

-- Quick save
map('n', '<leader>w', '<cmd>w<cr>', { desc = 'Save file' })

-- Better indenting (stay in visual mode)
map('v', '<', '<gv', { desc = 'Indent left' })
map('v', '>', '>gv', { desc = 'Indent right' })

-- Move lines up/down in visual mode
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Keep cursor centered on search/jumps
map('n', 'n', 'nzzzv', { desc = 'Next search (centered)' })
map('n', 'N', 'Nzzzv', { desc = 'Prev search (centered)' })
map('n', '<C-d>', '<C-d>zz', { desc = 'Half page down (centered)' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Half page up (centered)' })

-- Better paste (don't lose register in visual mode)
map('x', '<leader>p', '"_dP', { desc = 'Paste without yanking' })

-- Delete to void register (don't pollute clipboard)
map({ 'n', 'v' }, '<leader>d', '"_d', { desc = 'Delete to void' })

-- Quick quit/close
map('n', '<leader>q', '<cmd>q<cr>', { desc = 'Quit window' })
map('n', '<leader>Q', '<cmd>qa<cr>', { desc = 'Quit all' })

-- Clear search highlighting
map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlight' })

-- Diagnostic navigation
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic' })

-- Todo-comments navigation (if plugin installed)
map('n', ']t', function()
    require('todo-comments').jump_next()
end, { desc = 'Next todo comment' })
map('n', '[t', function()
    require('todo-comments').jump_prev()
end, { desc = 'Previous todo comment' })

-- Diffview keymaps
map('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = 'Git diff view' })
map('n', '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', { desc = 'Git file history' })
map('n', '<leader>gH', '<cmd>DiffviewFileHistory<cr>', { desc = 'Git branch history' })

-- Discord Rich Presence toggle
map('n', '<leader>cd', function()
    local server = require('cord.server')
    local is_paused = server.manager and server.manager.is_paused or false
    
    -- Toggle presence
    require('cord.api.command').toggle_presence()
    
    -- Show notification based on the toggle (opposite of current state)
    if is_paused then
        vim.notify('Discord Rich Presence: Enabled 🎮', vim.log.levels.INFO)
    else
        vim.notify('Discord Rich Presence: Disabled 🔇', vim.log.levels.INFO)
    end
end, { desc = 'Toggle Discord Rich Presence' })
