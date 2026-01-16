   # Neovim Config Usage Guide

This setup is based on **NvChad v2.5** with customizations for competitive programming and productivity. This document covers plugins, keymaps, and configuration details.

> **Note**: For complete Vim motions and operators reference, see [MOTIONS.md](./MOTIONS.md) which includes all keybinds and a comprehensive guide.

## Quick Navigation

- **All Keybinds**: See [MOTIONS.md](./MOTIONS.md) for complete keybind reference
- **Snippets**: See [SNIPPETS.md](./SNIPPETS.md) for C++ competitive programming snippets
- **In-Editor Help**: Press `<Space>fk` to search all keymaps interactively

---
## 1. Prerequisites

Install:
* Neovim >= 0.9
* Git
* A Nerd Font (for icons) – e.g. `FiraCode Nerd Font`

Optional external tools (installed automatically only if you enable them):
* LSP servers (via `mason` + `mason-lspconfig`)
* Linters (via `nvim-lint` + `mason-nvim-lint`)
* Formatters (via `conform.nvim` + `mason-conform`)

---
## 2. Installation

Clone into your Neovim config path (backup any existing config first):

```bash
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.cache/nvim
git clone https://github.com/samonide/nvim.git ~/.config/nvim
nvim
```

On first launch `lazy.nvim` & plugins will bootstrap automatically.

---
## 3. Directory Structure

| Path | Purpose |
|------|---------|
| `init.lua` | Bootstraps lazy.nvim & loads NvChad + your modules |
| `lua/chadrc.lua` | Theme / UI overrides (NvChad style) |
| `lua/options.lua` | Extra vim options (indent = 4 spaces, etc.) |
| `lua/mappings.lua` | Custom keymaps layered after NvChad defaults |
| `lua/plugins/init.lua` | Additional plugin specs |
| `lua/configs/*.lua` | Per‑plugin configuration modules |
| `lazy-lock.json` | Lock file for plugin versions |

---
## 4. Essential Keybinds Reference

> **Leader Key**: `Space` | **Full Reference**: [MOTIONS.md](./MOTIONS.md)

### Quick Access
| Key | Action | Description |
|-----|--------|-------------|
| `<Space>fk` | Search Keymaps | Find any keybind interactively (Telescope) |
| `;` | Enter Command | Faster than Shift+: |
| `jk` | Exit Insert | Quick escape from insert mode |

### Most Used Daily
| Key | Action |
|-----|--------|
| `<Space>ff` | Find files (fuzzy search) |
| `<Space>fg` | Live grep (search text in project) |
| `<Space>fb` | Find buffers (open files) |
| `<C-h/j/k/l>` | Navigate between splits |
| `<C-Tab>` | Next buffer (file) |
| `<C-Shift-Tab>` | Previous buffer |
| `<Space>bd` | Close current buffer (`:bd`) |

### Terminal Management
| Key | Action |
|-----|--------|
| `Alt+i` | Toggle floating terminal |
| `Alt+h` | Toggle horizontal terminal |
| `Alt+v` | Toggle vertical terminal |
| `<Space>ft` | Toggle floating terminal (alternative) |

**Note**: Alt+h and Alt+v work in both normal and terminal mode for easy toggling.

### Competitive Programming
| Key | Action |
|-----|--------|
| `<Space>cr` | Compile & run C++ |
| `<Space>cb` | Build only (compile) |
| `<Space>ci` | Run with input.txt |
| `<C-A-n>` | Run input.txt → output.txt |
| `<Space>ct` | Run in floating terminal |
| `<Space>ctt` | Run all tests (tests/*.in) |
| `<Space>co` | Cycle optimization profile |
| `<Space>cw` | Toggle watch mode |
| `<Space>ch` | Run history |
| `<Space>cc` | Clean build directory |
| `<Space>tc` | Analyze complexity (timesense) |
| `<Space>tx` | View coding stats |

### Harpoon (Quick File Marks)
| Key | Action |
|-----|--------|
| `<Space>ha` | Add file to marks |
| `<Space>hh` | Show marks menu |
| `<Space>1-4` | Jump to mark 1-4 |

### LSP (Code Intelligence)
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Show references |
| `gi` | Go to implementation |
| `gD` | Go to declaration |
| `K` | Hover documentation |
| `<Space>rn` | Rename symbol |
| `<Space>ca` | Code actions |
| `<Space>lf` | Format document |
| `<Space>ls` | LSP info |
| `<Space>lr` | Restart LSP |
| `[d` / `]d` | Previous/next diagnostic |

### Trouble (Diagnostics UI)
| Key | Action |
|-----|--------|
| `<Space>td` | Toggle diagnostics |
| `<Space>tq` | Toggle quickfix |
| `<Space>tr` | Toggle references |

### Git Integration
| Key | Action |
|-----|--------|
| `<Space>gd` | Git diff view |
| `<Space>gh` | Git file history |
| `<Space>gH` | Git branch history |
| `<Space>gs` | Git status (Telescope) |
| `<Space>gc` | Git commits |
| `<Space>gb` | Git branches |

### Splits & Windows
| Key | Action |
|-----|--------|
| `<Space>sv` | Vertical split |
| `<Space>sh` | Horizontal split |
| `<Space>sx` | Close split |
| `<Space>se` | Equalize splits |
| `<C-Arrow>` | Resize splits |

### Editing Enhancements
| Key | Action |
|-----|--------|
| `gcc` | Toggle line comment |
| `gc{motion}` | Comment motion |
| `s` | Flash jump |
| `ys{motion}{char}` | Add surrounding |
| `cs{old}{new}` | Change surrounding |
| `ds{char}` | Delete surrounding |
| `<` / `>` (visual) | Indent (stays in visual) |
| `J` / `K` (visual) | Move lines up/down |
| `<Space>w` | Quick save |
| `<Space>q` | Quit window |

### Telescope Additions
| Key | Action |
|-----|--------|
| `<Space>fh` | Help tags |
| `<Space>fo` | Recent files |
| `<Space>fw` | Find word under cursor |
| `<Space>fc` | Find commands |
| `<Space>fk` | Find keymaps |
| `<Space>fs` | Document symbols |

### File Explorer
| Key | Action |
|-----|--------|
| `<Space>e` | Toggle NvimTree |
| `<Space>ef` | Focus NvimTree |

### Miscellaneous
| Key | Action |
|-----|--------|
| `<Space>cd` | Toggle Discord Rich Presence |
| `<Space>ts` | Toggle shell (zsh ↔ fish) |
| `<Esc>` | Clear search highlight |
| `[t` / `]t` | Previous/next TODO comment |

> **Complete Reference**: All keybinds with descriptions are in [MOTIONS.md](./MOTIONS.md)

---
## 5. Custom Keymaps Details

**Key Philosophy**:
- **No Conflicts**: All keybinds have been refactored to eliminate duplicates
- **Prefix System**: Organized by prefix (`<Space>f` for find, `<Space>c` for code, etc.)
- **Vim Standard**: Uses standard Vim conventions where applicable (`<C-hjkl>` for navigation)

**Clipboard Integration**:
- All yank operations automatically copy to system clipboard (`clipboard=unnamedplus`)
- Paste outside Neovim with system paste (Ctrl+V)

**Terminal Toggles**:
- Each terminal type (floating, horizontal, vertical) maintains separate sessions
- Terminals properly toggle (open/close) from both normal and terminal mode
- Press the same key again to close the terminal

**Buffer vs Window**:
- Buffer = file in memory (use `<Space>bd` to close)
- Window = viewport (use `<Space>sx` or `:q` to close)
- `;q` closes window, not buffer (use `<Space>bd` to close the file)

---
## 6. NvChad Default Keymaps (Selected)

These are inherited from NvChad core. For complete list, press `<Space>ch` (cheatsheet) in Neovim.

### Core Navigation
| Key | Action |
|-----|--------|
| `<C-n>` | Toggle file tree |
| `<C-s>` | Save file |
| `<C-c>` | Copy entire file |

### WhichKey
| Key | Action |
|-----|--------|
| `<Space>wK` | Show all keymaps |
| `<Space>wk` | WhichKey lookup |

### Theme
| Key | Action |
|-----|--------|
| `<Space>th` | Theme picker |

---
## 7. Plugins Included

### Core Framework
* `NvChad` – Base UI framework with themes, statusline, bufferline
* `lazy.nvim` – Modern plugin manager
* `telescope.nvim` + `telescope-fzf-native` – Fuzzy finder with native FZF sorter
* `which-key.nvim` – Keybinding discovery UI
* `nvim-tree.lua` – File explorer

### Language & Syntax
* `nvim-treesitter` + `nvim-treesitter-textobjects` – Syntax highlighting & smart text objects
* `nvim-lspconfig` – LSP client configurations
* `mason.nvim` + `mason-lspconfig.nvim` – LSP server auto-installer

### Formatting & Linting
* `conform.nvim` + `mason-conform.nvim` – Fast async formatting with format-on-save
* `nvim-lint` + `mason-nvim-lint` – Async linting engine

### UI & Experience
* `alpha-nvim` – Beautiful startup dashboard
* `noice.nvim` + `nvim-notify` – Enhanced UI for messages, cmdline, and notifications
* `dressing.nvim` – Better UI for inputs and selections
* `trouble.nvim` – Diagnostics & quickfix UI

### Competitive Programming
* `runner.nvim` – Fast code execution with test harness, I/O files, optimization profiles
* `timesense.nvim` – Code complexity analysis (O(n) hints) & coding statistics

### Navigation & Editing
* `harpoon` (v2) – Quick file marks and navigation
* `flash.nvim` – Lightning-fast label-based navigation
* `nvim-surround` – Add/change/delete surrounding pairs
* `Comment.nvim` – Treesitter-aware commenting
* `todo-comments.nvim` – Highlight & navigate TODO/FIXME/NOTE comments

### Snippets
* `LuaSnip` + `friendly-snippets` – Snippet engine with community snippets
* Custom C++ snippets (`cp` full template, `cb` simple boilerplate)

### Git Integration
* `diffview.nvim` – Git diff and file history viewer

### Optional
* `cord.nvim` – Discord Rich Presence (toggle with `<Space>cd`)

**Removed Plugins** (from previous versions):
- `overseer.nvim` – Replaced by runner.nvim for CP use cases
- `nvim-bqf` – Replaced by trouble.nvim's superior quickfix UI

---
## 8. LSP Setup

Current configured server in `configs/lspconfig.lua`:
* `lua_ls` (Lua language server) – Diagnostics explicitly disabled (`diagnostics.enable = false`).

To enable more servers:
1. Uncomment or add server names inside `lspconfig.servers` list.
2. (Optional) Add server-specific setups below (see commented examples for clangd, gopls, etc.).
3. Open Neovim; `mason-lspconfig` will ensure they're installed (unless filtered).

If you want automatic installation toggle `automatic_installation = true` in `configs/mason-lspconfig.lua`.

### Disabling Formatting From an LSP
Example pattern (already shown in comments): set `client.server_capabilities.documentFormattingProvider = false` in a server-specific `on_attach` wrapper when you rely solely on `conform`.

---
## 9. Treesitter

Configured languages (`ensure_installed` in `configs/treesitter.lua`):
`bash`, `fish`, `lua`, `luadoc`, `markdown`, `markdown_inline`, `printf`, `toml`, `vim`, `vimdoc`, `yaml`.

Enable more by adding to the list. Remove a language by deleting it.

### NEW: Treesitter Text Objects & Incremental Selection

The config now includes:
* **Incremental selection**: Press `<CR>` to expand selection, `<BS>` to shrink
* **Smart text objects**: `af`/`if` (function), `ac`/`ic` (class), `al`/`il` (loop), `aa`/`ia` (parameter)
* **Navigation**: `]f`/`[f` (next/prev function), `]c`/`[c` (next/prev class)

These work automatically with supported languages (C, C++, Python, Lua, etc.).

---
## 10. Formatting (`conform.nvim`)

Defined in `configs/conform.lua`:
* Filetype formatter map: `lua -> stylua`, `c/cpp -> clang-format` (others commented for reference).
* `format_on_save` enabled with 500ms timeout and LSP fallback.
* Manual trigger: `<leader>fm`.

To customize `stylua` args: uncomment & adjust the `stylua` section in `formatters`.

Add new filetypes by editing `formatters_by_ft`.

---
## 11. Linting (`nvim-lint`)

Configured in `configs/lint.lua`:
* Active: `lua` uses `luacheck` (args customized to treat `love`, `vim` as globals; outputs codes & ranges).
* Autocmd triggers lint on: `BufEnter`, `BufWritePost`, `InsertLeave`.
* Add more filetypes by extending `lint.linters_by_ft`.
* Installation of underlying linters can be automated via `mason-nvim-lint` (ensure the linter name matches a supported Mason package).

---
## 12. Indentation & Options

In `options.lua`: sets `shiftwidth`, `tabstop`, `softtabstop` to **4**.
Add further overrides there (cursorline, custom autocmds, etc.).

---
## 13. Theme & UI

Current theme: `bearded-arc` (set in `chadrc.lua`).
Change theme: edit that file & set another valid NvChad theme name, or run `<leader>th` to preview & then persist the choice manually.

### Dashboard (alpha.nvim)
Configured in `lua/configs/alpha.lua` with an ASCII header & buttons for common actions (find files, recent, grep, new file, projects, config, update plugins, quit). Loads automatically on `VimEnter` when no file args.

### Notifications & LSP UI (noice.nvim)
`noice.nvim` improves message routing, cmdline UI, and LSP markdown rendering. Presets enabled: bottom search, command palette, long messages to split, bordered docs. Customize in the spec inside `lua/plugins/init.lua`.

---
## 14. Adding New Keymaps

Place them in `lua/mappings.lua` after the `require "nvchad.mappings"` line. Example:

```lua
local map = vim.keymap.set
map("n", "<leader>qq", ":qa!<CR>", { desc = "Quit all" })
```

Use `desc` so WhichKey & the cheatsheet show them.

---
## 15. Adding Plugins

Add a spec to `lua/plugins/init.lua`:
```lua
{
	"folke/zen-mode.nvim",
	cmd = "ZenMode",
	config = function()
		require("zen-mode").setup {}
	end,
},
```
Restart or run `:Lazy sync`.

---
## 16. Managing Plugins
Useful commands:
| Command | Purpose |
|---------|---------|
| `:Lazy` | Open lazy.nvim UI |
| `:Lazy sync` | Install/update/remove to match specs |
| `:Lazy clean` | Remove stray plugins |
| `:Lazy check` | Show outdated |

`lazy-lock.json` pins versions; commit changes for reproducibility.

---
## 17. Troubleshooting
| Symptom | Tip |
|---------|-----|
| Treesitter highlight missing | Run `:TSInstall <lang>` or ensure language in list |
| Formatter not applied | Check filetype -> `:lua print(vim.bo.filetype)`; confirm in `formatters_by_ft` |
| LSP not starting | Run `:Mason`, ensure server installed; check `:LspInfo` |
| Lint not running | Confirm autocmd events triggered; run `:lua require('lint').try_lint()` manually |
| Icons broken | Install a Nerd Font & enable it in your terminal |

---
## 18. Extending Further
* Add statusline tweaks via NvChad UI overrides
* Configure diagnostics signs if re-enabling diagnostics for `lua_ls`
* Add judge integration script to auto-produce expected outputs
* Add valgrind / sanitizer task profiles in Overseer
* Add test generation or random stress testing harness (A/B testing)

---
## 19. Quick Start Recap
1. Clone repo
2. Open Neovim (`nvim`)
3. Wait for bootstrap
4. Press `<leader>ch` or `<leader>wK` to explore mappings
5. Start coding 🎯

---
## 20. Snippets Reference
See `SNIPPETS.md` for the full list of competitive programming C++ snippets (templates, DS, graphs, math, strings, utilities). Key snippets:
- **`cp`** - Full competitive programming template (typedefs, macros, solve function structure)
- **`cb`** - Simple C++ boilerplate for basic coding

Reload them after editing with:
```
:lua package.loaded["configs.cp_snippets"] = nil; require("configs.cp_snippets")
```

---
## 21. Configuration Philosophy

This setup follows these principles:

1. **Conflict-Free Keybinds**: No duplicate or overlapping keybinds
2. **Prefix Organization**: Logical grouping (`<Space>f` = find, `<Space>c` = code, etc.)
3. **Vim Standards**: Uses standard Vim conventions where applicable
4. **Clipboard Integration**: System clipboard sync enabled by default
5. **Smart Defaults**: Sensible options for productivity and competitive programming
6. **Minimal But Complete**: Essential plugins without bloat

### Recent Improvements (v2024.1)
- Fixed all keybind conflicts (no more duplicates)
- Removed redundant plugins (overseer, nvim-bqf)
- Improved terminal toggle behavior (separate buffers for each type)
- Added system clipboard sync
- Standardized window navigation to `<C-hjkl>`
- Changed buffer switching from Tab to `<C-Tab>`
- Updated LuaSnip navigation to `<C-n/p>` (no conflict with window nav)
- Simplified Harpoon shortcuts (`<Space>1-4` instead of `<Space>h1-4`)

---
## 22. Tips & Best Practices

### Learning the Setup
1. Start with `<Space>fk` to explore keybinds interactively
2. Press `<Space>` and wait – WhichKey shows available options
3. See [MOTIONS.md](./MOTIONS.md) for complete reference
4. Practice one prefix at a time (`<Space>f` for finding, `<Space>c` for code)

### Workflow Optimization
1. **File Navigation**: Use Harpoon for frequently-used files
   - `<Space>ha` to add file
   - `<Space>1-4` to jump instantly
2. **Searching**: `<Space>ff` for files, `<Space>fg` for text
3. **Terminals**: Alt+h/v for quick terminals (toggle from anywhere)
4. **Buffer Management**: `<C-Tab>` to cycle, `<Space>bd` to close

### Competitive Programming Workflow
1. Create `main.cpp`, type `cp<Tab>` for template
2. Write solution
3. Press `<Space>cr` to compile and run
4. Use `<Space>ci` with `input.txt` for testing
5. Run all tests with `<Space>ctt` (requires `tests/*.in` and `tests/*.out`)
6. Analyze complexity with `<Space>tc`

---
Happy hacking! Customize to your heart's content.

---
Navigation: [Snippets](./SNIPPETS.md) · [Motions](./MOTIONS.md)

