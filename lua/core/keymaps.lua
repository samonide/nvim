local opts = { noremap = true, silent = true }
local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

map("n", "<C-s>", ":w<CR>", opts)

-- [[ No highlight after pressing escape ]]
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Escape Highlight", silent = true })
map("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- [[ Move lines using <A-j,k> ]]
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- [[ Center Screen on C-d,u ]]
map("n", "<C-d>", "<C-d>zz", { desc = "bring screen to middle" })
map("n", "<C-u>", "<C-u>zz", { desc = "bring screen to middle" })

-- [[ Center on search jumps ]]
map("n", "n", "nzzzv", { desc = "Next search (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search (centered)" })

-- [[ Useful everyday keybinds ]]
map("x", "p", 'p:let @"=@0<CR>', { silent = true })
map("n", "<S-CR>", "O<Esc>", { desc = "Add new line above" })
map("n", "<CR>", "o<Esc>", { desc = "Add new line below" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "file save" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "file copy whole", noremap = true })

-- [[ Indentation Stuff ]]
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- [[ Insert mode escape ]]
map("i", "jk", "<ESC>", { desc = "Exit insert (jk)" })

-- [[ CMD mode shortcut ]]
map("n", ";", ":", { desc = "CMD enter command mode" })

-- [[ Clipboard / paste without yanking ]]
map("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete to void" })

-- [[ Wrap-aware movement ]]
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Move down (wrap-aware)" })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Move up (wrap-aware)" })

-- [[ Tabs Stuff ]]
map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
map("n", "<leader>tk", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
map("n", "]t", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
map("n", "[t", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
map("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- [[ Buffer Stuff ]]
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bo", '<cmd>write|%bdelete|edit #|normal`"<CR>', { desc = "Close all other buffers" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete buffer" })
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>ba", '<cmd>write|%bdelete|edit #|normal`"<CR>', { desc = "Close all buffers except current" })
map("n", "<C-Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<C-S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- [[ Quickfix Stuff ]]
map("n", "<leader>qf", function()
	local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
	if not success and err then
		vim.notify(err, vim.log.levels.WARN)
	end
end, { desc = "Quickfix List" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- [[ Diagnostics Stuff ]]
local diagnostic_goto = function(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity })
	end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- Terminal Mappings
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
map("t", "<C-x>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- [[ Window Navigation ]]
map("n", "<C-h>", "<C-w>h", { desc = "Focus left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus down split" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus up split" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus right split" })

-- [[ Split Management ]]
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<cr>", { desc = "Horizontal split" })
map("n", "<leader>sx", "<C-w>q", { desc = "Close split" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize split sizes" })

-- [[ Resize splits with arrow keys ]]
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- [[ Quick commands ]]
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit window" })
map("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "<leader>wa", "<cmd>wa<cr>", { desc = "Save all" })
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New file" })

-- [[ LSP stuff ]]
map("n", "K", vim.lsp.buf.hover, { desc = "LSP : Hover" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP : [C]ode [A]ction" })
map("n", "<leader>cf", vim.lsp.buf.format, { desc = "LSP : [C]ode [F]ormatting" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "[R]e[n]ame symbol" })
map("n", "<leader>ls", "<cmd>LspInfo<cr>", { desc = "LSP info" })
map("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })

-- Harpoon additions (keep g-prefixed maps and add leader-based ones from main branch)
map("n", "<leader>ha", function()
	local ok, harpoon = pcall(require, "harpoon")
	if not ok then
		return
	end
	harpoon:list():add()
end, { desc = "Harpoon add file" })

map("n", "<leader>hh", function()
	local ok, harpoon = pcall(require, "harpoon")
	if not ok then
		return
	end
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon menu" })

for i = 1, 4 do
	map("n", string.format("<leader>%d", i), function()
		local ok, harpoon = pcall(require, "harpoon")
		if not ok then
			return
		end
		harpoon:list():select(i)
	end, { desc = "Harpoon select #" .. i })
end

-- Telescope (matches main branch cheatsheet)
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
map("n", "<leader>fw", "<cmd>Telescope grep_string<cr>", { desc = "Find word under cursor" })
map("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "Find commands" })
map("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find keymaps" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document symbols" })

-- Trouble diagnostics toggles
map("n", "<leader>td", "<cmd>Trouble diagnostics toggle focus=true<CR>", { desc = "Trouble diagnostics" })
map("n", "<leader>tq", "<cmd>Trouble qflist toggle<CR>", { desc = "Trouble quickfix" })
map("n", "<leader>tr", "<cmd>Trouble lsp_references toggle focus=true<CR>", { desc = "Trouble references" })

-- Runner (code execution helpers)
map("n", "<leader>cr", "<cmd>RunCode<cr>", { desc = "Run code" })
map("n", "<leader>cb", "<cmd>RunBuild<cr>", { desc = "Build only" })
map("n", "<leader>ce", "<cmd>RunLast<cr>", { desc = "Run last build" })
map("n", "<leader>ci", "<cmd>RunWithInput<cr>", { desc = "Run with input.txt" })
map("n", "<leader>ct", "<cmd>RunFloat<cr>", { desc = "Run in floating terminal" })
map("n", "<leader>ctt", "<cmd>RunTests<cr>", { desc = "Run all tests" })
map("n", "<leader>co", "<cmd>RunProfile<cr>", { desc = "Cycle optimization profile" })
map("n", "<leader>cw", "<cmd>RunWatch<cr>", { desc = "Toggle watch mode" })
map("n", "<leader>ch", "<cmd>RunHistory<cr>", { desc = "Show run history" })
map("n", "<leader>cc", "<cmd>RunClean<cr>", { desc = "Clean build directory" })
map("n", "<C-A-n>", "<cmd>RunIOFiles<cr>", { desc = "Run with input/output files" })

-- Timesense (complexity and stats)
map("n", "<leader>tc", "<cmd>Timesense complexity<cr>", { desc = "Timesense complexity analysis" })
map("n", "<leader>tx", "<cmd>Timesense stats<cr>", { desc = "Timesense coding stats" })

-- Todo-comments navigation
map("n", "]t", function()
	local ok, todo = pcall(require, "todo-comments")
	if ok then
		todo.jump_next()
	end
end, { desc = "Next todo comment" })

map("n", "[t", function()
	local ok, todo = pcall(require, "todo-comments")
	if ok then
		todo.jump_prev()
	end
end, { desc = "Previous todo comment" })

-- Toggle shell between zsh and fish inside Neovim terminal
map("n", "<leader>ts", function()
	local current = vim.o.shell
	local zsh = (vim.fn.executable("/usr/bin/zsh") == 1 and "/usr/bin/zsh") or (vim.fn.executable("/bin/zsh") == 1 and "/bin/zsh")
	local fish = (vim.fn.executable("/usr/bin/fish") == 1 and "/usr/bin/fish") or (vim.fn.executable("/bin/fish") == 1 and "/bin/fish")
	if current == zsh and fish then
		vim.o.shell = fish
		vim.notify("Shell set to fish (Neovim only)")
	elseif zsh then
		vim.o.shell = zsh
		vim.notify("Shell set to zsh (Neovim only)")
	else
		vim.notify("No zsh found; shell unchanged", vim.log.levels.WARN)
	end
end, { desc = "Toggle shell zsh<->fish (nvim term)" })

-- Diffview helpers (kept on uppercase variants to avoid clashing with gitsigns)
map("n", "<leader>gD", "<cmd>DiffviewOpen<cr>", { desc = "Git diff view" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", { desc = "Git file history" })
map("n", "<leader>gB", "<cmd>DiffviewFileHistory<cr>", { desc = "Git branch history" })
