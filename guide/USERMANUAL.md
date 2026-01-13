   # Neovim Config Usage Guide

This setup is based on **NvChad v2.5** with a minimal layer of customizations. This document lists the key plugins, keymaps (both custom & important NvChad defaults), and how to extend the configuration.

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
## 3. Directory Structure (Relevant Files)

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
## 4. Custom Keymaps (Defined in `lua/mappings.lua`)

| Mode | LHS | RHS | Description |
|------|-----|-----|-------------|
| Normal | `;` | `:` | Enter command mode (faster than Shift-;) |
| Insert | `jk` | `<Esc>` | Quick escape |

Your `<leader>` is set to: **Space** (`vim.g.mapleader = ' '`).

> The `<C-s>` mapping for save is commented out; uncomment if you want Ctrl+S across modes.

### Competitive Programming Helpers
Added functions to compile & run the current C/C++ file using optimized flags and open a reusable terminal.

| Key | Action |
|-----|--------|
| `<leader>cr` | Compile & run current C/C++ file (`g++ -std=c++17 -O2 -Wall -Wextra -Wshadow`) |
| `<leader>cb` | Alias of compile & run (build) |
| `<leader>ce` | Execute last built binary (no rebuild) |
| `<leader>ci` | Run C++ with input.txt in terminal (creates file if missing) |
| `<leader>ct` | Build & run C++ in floating terminal |
| `<leader>ctt` | Run all tests in `tests/*.in` comparing outputs with matching `.out` |
| `<leader>co` | Cycle optimization profile (O2 ↔ Ofast) |
| `<C-A-n>` | **NEW**: Run C++ with input.txt → output.txt (auto-creates files) |
| `<leader>tc` | **NEW**: Analyze code complexity (timesense) |
| `<leader>tx` | **NEW**: View coding statistics (timesense) |
| `<leader>ha` | Harpoon add current file |
| `<leader>hm` | Harpoon quick menu |
| `<leader>h1..h4` | Harpoon jump slots 1–4 |
| `<leader>h` / `<leader>v` | **CHANGED**: Focus left/right split (was terminal) |
| `<A-h>` / `<A-v>` | **NEW**: Toggle horizontal/vertical terminal |
| `<leader>ft` | **NEW**: Toggle floating terminal |
| `<leader>tt` | Toggle terminal split (legacy) |
| `<leader>td` | Trouble diagnostics toggle |
| `<leader>tq` | Trouble quickfix toggle |
| `<leader>tr` | Trouble LSP references toggle |
| `<leader>ot` | Overseer task list |
| `<leader>or` | Overseer run task |
| `<C-j>` / `<C-k>` | LuaSnip expand/jump forward / backward (insert/select) |

### Productivity Enhancements (NEW)
| Key | Action |
|-----|--------|
| `j` / `k` | Smart movement (wrap-aware with count) |
| `<leader>w` | Quick save file |
| `<leader>q` / `<leader>Q` | Quit window / Quit all |
| `<leader>d` | Delete to void register (don't pollute clipboard) |
| `<leader>p` (visual) | Paste without yanking selection |
| `<` / `>` (visual) | Indent and stay in visual mode |
| `J` / `K` (visual) | Move selection down/up |
| `n` / `N` | Next/prev search (centered) |
| `<C-d>` / `<C-u>` | Half page scroll (centered) |
| `<Esc>` | Clear search highlight |
| `[d` / `]d` | Previous/next diagnostic |
| `[t` / `]t` | Previous/next TODO comment |
| `<leader>e` | Show diagnostic float |
| `<leader>gd` | Git diff view |
| `<leader>gh` | Git file history |
| `<leader>gH` | Git branch history |
| `<leader>cd` | Toggle Discord Rich Presence |

### Flash Navigation (NEW)
| Key | Action |
|-----|--------|
| `s` | Flash jump to any location |
| `S` | Flash treesitter node selection |
| `r` (operator) | Remote flash for operations |
| `R` (visual/operator) | Treesitter search |

### Surround Operations (NEW)
| Key | Action |
|-----|--------|
| `ys{motion}{char}` | Add surrounding (e.g., `ysiw"` surrounds word with quotes) |
| `cs{old}{new}` | Change surrounding (e.g., `cs"'` changes " to ') |
| `ds{char}` | Delete surrounding (e.g., `ds"` removes quotes) |
| `yss{char}` | Surround entire line |

### Smart Commenting (NEW)
| Key | Action |
|-----|--------|
| `gcc` | Toggle line comment |
| `gbc` | Toggle block comment |
| `gc{motion}` | Comment motion (e.g., `gcap` for paragraph) |
| `gb{motion}` | Block comment motion |

### Treesitter Text Objects (NEW)
| Key | Action |
|-----|--------|
| `<CR>` | Expand selection incrementally (press repeatedly) |
| `<BS>` | Shrink selection |
| `af` / `if` | Select outer/inner function |
| `ac` / `ic` | Select outer/inner class |
| `al` / `il` | Select outer/inner loop |
| `aa` / `ia` | Select outer/inner parameter |
| `]f` / `[f` | Next/previous function |
| `]c` / `[c` | Next/previous class |
| `]F` / `[F` | Next/previous function end |
| `[C` / `]C` | Previous/next class end |

Build artifacts go into a `.build/` folder inside the current working directory. The terminal buffer id used: `cp_run_term` (reused each run).

---
## 5. Essential NvChad Default Keymaps (Quick Reference)

These come from upstream NvChad (`nvchad/mappings.lua`). Only the most commonly used are listed here. Use `<leader>ch` (cheatsheet) or `<leader>wK` (WhichKey all) for a full in-editor list.

### General
| Key | Action |
|-----|--------|
| `<Esc>` | Clear search highlight |
| `<C-s>` | Save buffer (normal mode) |
| `<C-c>` | Yank entire file to system clipboard |
| `<leader>n` | Toggle absolute line numbers |
| `<leader>rn` | Toggle relative line numbers |
| `<leader>ch` | NvChad cheatsheet popup |
| `<leader>fm` | Format buffer via `conform` (LSP fallback) |

### Window & Cursor Movement
| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Move between windows |
| In insert: `<C-b>` / `<C-e>` | Start / end of line |
| In insert: `<C-h/j/k/l>` | Cursor move directions |

### Buffers / Tabs
| Key | Action |
|-----|--------|
| `<tab>` / `<S-tab>` | Next / previous buffer (tabufline) |
| `<leader>b` | New empty buffer |
| `<leader>x` | Close current buffer |

### File Tree (nvim-tree)
| Key | Action |
|-----|--------|
| `<C-n>` | Toggle tree |
| `<leader>e` | Focus tree window |

### Telescope (Fuzzy Finder)
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files (respects ignores) |
| `<leader>fa` | Find all files (including hidden & ignored) |
| `<leader>fw` | Live grep (ripgrep required) |
| `<leader>fb` | Buffers list |
| `<leader>fh` | Help tags |
| `<leader>fo` | Old files |
| `<leader>fz` | Fuzzy find in current buffer |
| `<leader>cm` | Git commits |
| `<leader>gt` | Git status |
| `<leader>ma` | Marks |
| `<leader>pt` | Toggle / pick hidden terminals |
| `<leader>th` | Theme selector |

### Commenting (mini-comment / ts-context aware)
| Key | Action |
|-----|--------|
| `<leader>/` (normal) | Toggle line comment |
| `<leader>/` (visual) | Toggle selection comment |

### Terminals
| Key | Action |
|-----|--------|
| `<A-h>` / `<A-v>` | Toggle horizontal / vertical persistent terminal |
| `<A-i>` | Toggle floating terminal |
| `<leader>ft` | Toggle floating terminal (alternative) |
| `<leader>tt` | Toggle terminal split (custom) |
| Terminal mode: `<C-x>` | Exit to normal mode |

**Note**: Default `<leader>h` / `<leader>v` terminal mappings disabled in favor of split navigation.

**Closing terminals without exit:**
- Press `<C-\><C-n>` to enter Normal mode, then `:q` to close the terminal window
- Or use the same toggle key again (`<A-i>`, `<leader>ft`, etc.) to hide floating/persistent terminals

### LSP (Core subset)
| Key | Action |
|-----|--------|
| `gd` | Goto definition |
| `gD` | Goto declaration |
| `gr` | References |
| `gi` | Goto implementation |
| `K` | Hover docs |
| `<leader>ra` | Code action (rename if configured) |
| `<leader>ca` | Code action menu |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>ds` | Populate loclist with diagnostics |
| `<leader>fm` | Format buffer (see Formatting section) |

> Exact LSP mappings come from NvChad defaults; if you need the full list open the cheatsheet.

### WhichKey
| Key | Action |
|-----|--------|
| `<leader>wK` | Show all registered keymaps |
| `<leader>wk` | Prompted WhichKey lookup |

---
## 6. Plugins Included (Custom Layer)

Defined in `lua/plugins/init.lua`:
* `nvim-treesitter` – Syntax highlighting & indent
* `nvim-treesitter-textobjects` – Smart text objects for code navigation
* `nvim-lspconfig` – Base LSP client setups
* `mason-lspconfig.nvim` – Ensures LSP servers installation
* `nvim-lint` + `mason-nvim-lint` – Linting layer
* `conform.nvim` + `mason-conform.nvim` – Formatting layer with format-on-save
* `alpha-nvim` – Startup dashboard (ASCII header, quick buttons)
* `noice.nvim` – Enhanced UI for messages, cmdline, LSP popups
* `harpoon` – Rapid file mark & jump navigation
* `telescope-fzf-native` – Native fzf sorter for faster Telescope search
* `overseer.nvim` – Task orchestration (compile/run/test integration base)
* **NEW**: `runner.nvim` – Fast code execution with test harness, I/O files, and multiple terminal modes
* **NEW**: `timesense.nvim` – Code complexity analysis (inline O(n) hints) & coding statistics tracker
* `trouble.nvim` – Diagnostics & references list UI
* `LuaSnip` + `friendly-snippets` – Snippet engine + community snippets (custom C++ snippets: `cp` for full competitive template, `cb` for simple boilerplate)
* **NEW**: `cord.nvim` – Discord Rich Presence integration
* **NEW**: `nvim-surround` – Add/change/delete surrounding pairs (quotes, brackets, tags)
* **NEW**: `Comment.nvim` – Enhanced commenting with treesitter integration
* **NEW**: `todo-comments.nvim` – Highlight & navigate TODO/FIXME/NOTE/HACK/PERF comments
* **NEW**: `flash.nvim` – Lightning-fast navigation with label jumps
* **NEW**: `nvim-bqf` – Better quickfix list with preview
* **NEW**: `diffview.nvim` – Git diff and file history viewer
* **NEW**: `dressing.nvim` – Better UI for vim.ui.select/input (prettier LSP actions)

NvChad core already brings: telescope, nvim-tree, bufferline (tabufline), statusline, themes, terminal manager, which-key integration, commenting, etc.

---
## 7. LSP Setup

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
## 8. Treesitter

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
## 9. Formatting (`conform.nvim`)

Defined in `configs/conform.lua`:
* Filetype formatter map: `lua -> stylua`, `c/cpp -> clang-format` (others commented for reference).
* `format_on_save` enabled with 500ms timeout and LSP fallback.
* Manual trigger: `<leader>fm`.

To customize `stylua` args: uncomment & adjust the `stylua` section in `formatters`.

Add new filetypes by editing `formatters_by_ft`.

---
## 10. Linting (`nvim-lint`)

Configured in `configs/lint.lua`:
* Active: `lua` uses `luacheck` (args customized to treat `love`, `vim` as globals; outputs codes & ranges).
* Autocmd triggers lint on: `BufEnter`, `BufWritePost`, `InsertLeave`.
* Add more filetypes by extending `lint.linters_by_ft`.
* Installation of underlying linters can be automated via `mason-nvim-lint` (ensure the linter name matches a supported Mason package).

---
## 11. Indentation & Options

In `options.lua`: sets `shiftwidth`, `tabstop`, `softtabstop` to **4**.
Add further overrides there (cursorline, custom autocmds, etc.).

---
## 12. Theme & UI

Current theme: `bearded-arc` (set in `chadrc.lua`).
Change theme: edit that file & set another valid NvChad theme name, or run `<leader>th` to preview & then persist the choice manually.

### Dashboard (alpha.nvim)
Configured in `lua/configs/alpha.lua` with an ASCII header & buttons for common actions (find files, recent, grep, new file, projects, config, update plugins, quit). Loads automatically on `VimEnter` when no file args.

### Notifications & LSP UI (noice.nvim)
`noice.nvim` improves message routing, cmdline UI, and LSP markdown rendering. Presets enabled: bottom search, command palette, long messages to split, bordered docs. Customize in the spec inside `lua/plugins/init.lua`.

---
## 13. Adding New Keymaps

Place them in `lua/mappings.lua` after the `require "nvchad.mappings"` line. Example:

```lua
local map = vim.keymap.set
map("n", "<leader>qq", ":qa!<CR>", { desc = "Quit all" })
```

Use `desc` so WhichKey & the cheatsheet show them.

---
## 14. Adding Plugins

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
## 15. Managing Plugins
Useful commands:
| Command | Purpose |
|---------|---------|
| `:Lazy` | Open lazy.nvim UI |
| `:Lazy sync` | Install/update/remove to match specs |
| `:Lazy clean` | Remove stray plugins |
| `:Lazy check` | Show outdated |

`lazy-lock.json` pins versions; commit changes for reproducibility.

---
## 16. Troubleshooting
| Symptom | Tip |
|---------|-----|
| Treesitter highlight missing | Run `:TSInstall <lang>` or ensure language in list |
| Formatter not applied | Check filetype -> `:lua print(vim.bo.filetype)`; confirm in `formatters_by_ft` |
| LSP not starting | Run `:Mason`, ensure server installed; check `:LspInfo` |
| Lint not running | Confirm autocmd events triggered; run `:lua require('lint').try_lint()` manually |
| Icons broken | Install a Nerd Font & enable it in your terminal |

---
## 17. Extending Further
* Add statusline tweaks via NvChad UI overrides
* Configure diagnostics signs if re-enabling diagnostics for `lua_ls`
* Add judge integration script to auto-produce expected outputs
* Add valgrind / sanitizer task profiles in Overseer
* Add test generation or random stress testing harness (A/B testing)

---
## 18. Quick Start Recap
1. Clone repo
2. Open Neovim (`nvim`)
3. Wait for bootstrap
4. Press `<leader>ch` or `<leader>wK` to explore mappings
5. Start coding 🎯

---
## 19. Snippets Reference
See `SNIPPETS.md` for the full list of competitive programming C++ snippets (templates, DS, graphs, math, strings, utilities). Key snippets:
- **`cp`** - Full competitive programming template (typedefs, macros, solve function structure)
- **`cb`** - Simple C++ boilerplate for basic coding

Reload them after editing with:
```
:lua package.loaded["configs.cp_snippets"] = nil; require("configs.cp_snippets")
```

---
## 20. NEW Features Summary (Latest Update)

### Enhanced Productivity
- **Discord Rich Presence**: Show what you're coding in Discord (auto-enabled)
- **Flash Navigation**: Jump anywhere with `s` + character labels
- **Smart Surround**: Easily manipulate quotes, brackets, tags with `ys`/`cs`/`ds`
- **Better Commenting**: Treesitter-aware commenting with `gcc`/`gbc`
- **TODO Highlighting**: Automatic highlighting of TODO/FIXME/NOTE/HACK/PERF comments
- **Treesitter Text Objects**: Select/navigate functions, classes with `af`, `if`, `]f`, etc.
- **Incremental Selection**: Press `<CR>` repeatedly to expand selection intelligently
- **Git Integration**: View diffs and history with `<leader>gd`, `<leader>gh`
- **Better Quickfix**: Enhanced quickfix list with preview
- **Prettier UI**: Better dialogs for LSP actions and inputs

### Quality of Life Improvements
- Cursor stays centered on jumps/searches (`n`, `N`, `<C-d>`, `<C-u>`)
- Better visual mode (indent without losing selection)
- Move lines in visual mode with `J`/`K`
- Smart paste that doesn't yank (`<leader>p` in visual)
- Wrap-aware j/k movement
- Quick save with `<leader>w`
- Better split navigation (`<leader>h`, `<leader>v`)
- Persistent undo, better defaults (scrolloff, updatetime, etc.)

### Commands to Explore
- `:Noice` or `:Noice history` - View all notifications/messages history
- `:TodoTelescope` - Search all TODO comments
- `:Cord toggle presence` or `<leader>cd` - Toggle Discord Rich Presence
- `:DiffviewOpen` - Open git diff view
- `:DiffviewFileHistory %` - See current file's history
- Use `<leader>ch` to see the full cheatsheet

---
Happy hacking! Customize boldly—this setup is purposely minimal so you can grow it organically.

---
Navigation: [Snippets](./SNIPPETS.md) · [Motions](./MOTIONS.md)

