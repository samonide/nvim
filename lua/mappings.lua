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
	-- termopen executes immediately; pass list for safety (handles spaces)
	if type(cmd) == 'string' then
		vim.fn.termopen(cmd)
	else
		vim.fn.termopen(cmd)
	end
	vim.cmd("startinsert")
	vim.g.cp_term_buf = buf
end

local function build_and_run_cpp()
	local ft = vim.bo.filetype
	if ft ~= "cpp" and ft ~= "c" then
		vim.notify("Not a C/C++ file", vim.log.levels.WARN)
		return
	end
	local filename = vim.fn.expand('%:t')
	local filepath = vim.fn.expand('%:p')
	local base = vim.fn.expand('%:t:r')
	local outdir = vim.fn.getcwd() .. "/.build" -- local build cache folder
	vim.fn.mkdir(outdir, 'p')
	local output = outdir .. "/" .. base
	local cmd
	if ft == 'cpp' then
		cmd = string.format('g++ -std=c++17 -O2 -Wall -Wextra -Wshadow -pedantic "%s" -o "%s"', filepath, output)
	else
		cmd = string.format('gcc -O2 -Wall -Wextra -pedantic "%s" -o "%s"', filepath, output)
	end
	vim.notify('Compiling ' .. filename .. ' ...', vim.log.levels.INFO)
	vim.fn.jobstart(cmd, {
		stdout_buffered = true,
		stderr_buffered = true,
		on_exit = function(_, code)
			if code == 0 then
				vim.notify('Build success: ' .. output, vim.log.levels.INFO)
				open_cp_term(output)
			else
				vim.notify('Build failed (code ' .. code .. ')', vim.log.levels.ERROR)
			end
		end,
	})
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

-- Quick open input.txt in split for manual IO during contests
map('n', '<leader>ci', function()
	vim.cmd('vsplit input.txt')
end, { desc = 'Open input.txt in vsplit' })

-- Feed input.txt to last built binary (if exists)
map('n', '<leader>ct', function()
	local base = vim.fn.expand('%:t:r')
	local bin = vim.fn.getcwd() .. '/.build/' .. base
	if vim.fn.filereadable(bin) == 0 then
		vim.notify('Binary not found. Build first (<leader>cr)', vim.log.levels.WARN)
		return
	end
	if vim.fn.filereadable('input.txt') == 0 then
		vim.notify('input.txt missing in cwd', vim.log.levels.WARN)
		return
	end
	open_cp_term(string.format('%s < input.txt', bin))
end, { desc = 'Run binary with input.txt redirected' })

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
	local base = vim.fn.expand('%:t:r')
	local bin = vim.fn.getcwd() .. '/.build/' .. base
	if vim.fn.filereadable(bin) == 0 then
		vim.notify('Binary not built. Building now...', vim.log.levels.INFO)
		build_and_run_cpp() -- will also run once, acceptable
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
	
	-- Check if binary exists, build if not
	if vim.fn.filereadable(bin) == 0 then
		vim.notify('Binary not found. Building first...', vim.log.levels.INFO)
		-- Build first, then run with IO
		build_and_run_cpp()
		vim.defer_fn(function()
			if vim.fn.filereadable(bin) == 1 then
				local cmd = string.format('%s < %s > %s', bin, input_file, output_file)
				vim.fn.system(cmd)
				vim.notify('Output written to output.txt', vim.log.levels.INFO)
				-- Open output.txt in split
				vim.cmd('vsplit output.txt')
			end
		end, 1000) -- Wait 1s for build to complete
		return
	end
	
	-- Run with input/output redirection
	local cmd = string.format('%s < %s > %s', bin, input_file, output_file)
	local result = vim.fn.system(cmd)
	local exit_code = vim.v.shell_error
	
	if exit_code == 0 then
		vim.notify('Success! Output written to output.txt', vim.log.levels.INFO)
		-- Open output.txt in split
		vim.cmd('vsplit output.txt')
	else
		vim.notify('Runtime error (code ' .. exit_code .. ')', vim.log.levels.ERROR)
	end
end

map('n', '<C-A-n>', run_with_io_files, { desc = 'Run C++ with input.txt -> output.txt' })

-- =============================================
-- Optimization profile toggle for C++
-- =============================================
local opt_profiles = {
	{ name = 'O2', cpp = '-O2 -Wall -Wextra -Wshadow -pedantic', c = '-O2 -Wall -Wextra -pedantic' },
	{ name = 'Ofast', cpp = '-Ofast -march=native -DNDEBUG -Wall -Wextra -Wshadow', c = '-Ofast -march=native -DNDEBUG -Wall -Wextra' },
}
local current_profile = 1
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
local old_build = build_and_run_cpp
build_and_run_cpp = function()
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
	local output = outdir .. '/' .. base
	local profile = opt_profiles[current_profile]
	local flags = ft == 'cpp' and profile.cpp or profile.c
	local compiler = ft == 'cpp' and 'g++ -std=c++17' or 'gcc'
	local cmd = string.format('%s %s "%s" -o "%s"', compiler, flags, filepath, output)
	vim.notify('Compiling (' .. profile.name .. '): ' .. filename, vim.log.levels.INFO)
	vim.fn.jobstart(cmd, {
		stdout_buffered = true,
		stderr_buffered = true,
		on_exit = function(_, code)
			if code == 0 then
				vim.notify('Build success: ' .. output, vim.log.levels.INFO)
				open_cp_term(output)
			else
				vim.notify('Build failed (code ' .. code .. ')', vim.log.levels.ERROR)
			end
		end,
	})
end

-- =============================================
-- LuaSnip navigation (if using luasnip)
-- =============================================
map({ 'i', 's' }, '<C-j>', function()
	local ls = require('luasnip')
	if ls.expand_or_jumpable() then ls.expand_or_jump() end
end, { desc = 'Snippet expand/jump forward' })
map({ 'i', 's' }, '<C-k>', function()
	local ls = require('luasnip')
	if ls.jumpable(-1) then ls.jump(-1) end
end, { desc = 'Snippet jump backward' })

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

		-- Create new terminal buffer
		if dir == 'v' then vim.cmd('botright vsplit') else vim.cmd('botright 15split') end
	vim.cmd('enew')
	local new_buf = vim.api.nvim_get_current_buf()
	vim.fn.termopen(vim.o.shell)
	vim.g.toggle_term_buf = new_buf
	vim.cmd('startinsert')
end
	map('n', '<A-h>', function() toggle_term('h') end, { desc = 'Toggle horizontal terminal' })
	map('n', '<A-v>', function() toggle_term('v') end, { desc = 'Toggle vertical terminal' })
