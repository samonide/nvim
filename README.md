<div align="center">

# Neovim Config (NvChad v2.5 Layer)

Minimal, fast, and competitive-programming friendly Neovim setup built on top of **NvChad**.

![Status](https://img.shields.io/badge/status-active-success?style=flat-square) ![Neovim](https://img.shields.io/badge/Neovim-%3E=0.9-green?style=flat-square)

</div>

## ✨ Highlights

* NvChad core (theme system, statusline, bufferline, tree, telescope)
* Competitive Programming helpers (compile/run, test harness, optimization profiles)
* Dashboard (alpha.nvim) + Enhanced UI (noice.nvim)
* Diagnostics UI (trouble.nvim) & Quick Navigation (harpoon)
* Tasks (overseer.nvim) & Formatting/Linting (conform + nvim-lint)
* Snippets (LuaSnip + friendly-snippets + custom `cp` C++ template)

Full usage & keymaps: see [`use.md`](./use.md).

## 📦 Installation Options

### Option A: Fresh Install (Replace Existing Config)
```bash
backup_dir="$HOME/.config/nvim_backup_$(date +%s)" && \
mv ~/.config/nvim "$backup_dir" 2>/dev/null || true && \
mv ~/.local/share/nvim "$backup_dir-data" 2>/dev/null || true && \
mv ~/.cache/nvim "$backup_dir-cache" 2>/dev/null || true && \
git clone <your-fork-or-repo-url> ~/.config/nvim && \
nvim
```

### Option B: Git Subdirectory (Manage as Git Submodule in dotfiles)
```bash
mkdir -p ~/.config && \
git submodule add <repo-url> ~/.config/nvim || git clone <repo-url> ~/.config/nvim && \
nvim
```

### Option C: Try Ephemeral (No Overwrite) Using `XDG_CONFIG_HOME`
```bash
TMPDIR=$(mktemp -d)
git clone <repo-url> "$TMPDIR/nvim"
XDG_CONFIG_HOME="$TMPDIR" XDG_DATA_HOME="$TMPDIR/data" XDG_STATE_HOME="$TMPDIR/state" XDG_CACHE_HOME="$TMPDIR/cache" nvim
```

## 🚀 Quick Start
1. Launch Neovim (`nvim`).
2. Let `lazy.nvim` install plugins.
3. Open the dashboard (auto) or run `:Alpha`.
4. Press `<leader>ch` (NvChad cheatsheet) or `<leader>wK` (WhichKey) to explore.
5. For C++: create `main.cpp` (template inserts automatically), then `<leader>cr` to compile & run.

## 🗂 Structure
| Path | Purpose |
|------|---------|
| `init.lua` | Entry point: bootstraps plugin manager + mappings |
| `lua/chadrc.lua` | NvChad UI & theme overrides |
| `lua/options.lua` | Core editor options & shell override |
| `lua/mappings.lua` | All custom keymaps (CP + tooling) |
| `lua/plugins/` | Additional plugin specs |
| `lua/configs/` | Per-plugin configuration modules |
| `use.md` | Comprehensive user & keymap manual |

## 🧠 Competitive Programming Toolkit
Feature | Keymaps
--------|--------
Compile & Run | `<leader>cr` / `<leader>cb`
Run last binary | `<leader>ce`
Run tests (tests/*.in) | `<leader>ctt`
Optimization profile cycle | `<leader>co`
Redirect input.txt | `<leader>ct`
Open input.txt | `<leader>ci`

## 🔧 Customization Tips
* Add more LSP servers in `configs/lspconfig.lua` & rerun Neovim.
* Extend Treesitter parsers in `configs/treesitter.lua`.
* Add formatters/linters via conform / nvim-lint config files.
* Place new snippets with LuaSnip in a dedicated module or VSCode-style JSON.

## ♻️ Updating
```bash
cd ~/.config/nvim
git pull --rebase
:Lazy sync
```

Commit `lazy-lock.json` to lock plugin versions.

## 🐛 Troubleshooting (Quick)
Issue | Check
------|------
Missing highlight | `:TSInstall <lang>`
Formatter not running | `<leader>fm` / check filetype mapping
LSP inactive | `:LspInfo` / `:Mason`
Test harness mismatch | Ensure `tests/*.out` files exist

## 📜 License
See [`LICENSE`](./LICENSE).

---
Happy hacking! For deep usage details, read the full manual in [`use.md`](./use.md).# Neovim Config Usage Guide

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
git clone <your-repo-url> ~/.config/nvim
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
| `<leader>ci` | Open `input.txt` in a vertical split (create if missing) |
| `<leader>ct` | Run last binary with `input.txt` as stdin (`binary < input.txt`) |
| `<leader>ctt` | Run all tests in `tests/*.in` comparing outputs with matching `.out` |
| `<leader>co` | Cycle optimization profile (O2 ↔ Ofast) |
| `<leader>ha` | Harpoon add current file |
| `<leader>hm` | Harpoon quick menu |
| `<leader>h1..h4` | Harpoon jump slots 1–4 |
| `<leader>td` | Trouble diagnostics toggle |
| `<leader>tq` | Trouble quickfix toggle |
| `<leader>tr` | Trouble LSP references toggle |
| `<leader>ot` | Overseer task list |
| `<leader>or` | Overseer run task |
| `<C-j>` / `<C-k>` | LuaSnip expand/jump forward / backward (insert/select) |

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
| `<leader>h` | New horizontal terminal |
| `<leader>v` | New vertical terminal |
| `<A-h>` / `<A-v>` | Toggle horizontal / vertical persistent term |
| `<A-i>` | Toggle floating terminal |
| Terminal mode: `<C-x>` | Exit to normal mode |

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
* `nvim-lspconfig` – Base LSP client setups
* `mason-lspconfig.nvim` – Ensures LSP servers installation
* `nvim-lint` + `mason-nvim-lint` – Linting layer
* `conform.nvim` + `mason-conform.nvim` – Formatting layer with format-on-save
* `alpha-nvim` – Startup dashboard (ASCII header, quick buttons)
* `noice.nvim` – Enhanced UI for messages, cmdline, LSP popups
* `harpoon` – Rapid file mark & jump navigation
* `telescope-fzf-native` – Native fzf sorter for faster Telescope search
* `overseer.nvim` – Task orchestration (compile/run/test integration base)
* `trouble.nvim` – Diagnostics & references list UI
* `LuaSnip` + `friendly-snippets` – Snippet engine + community snippets (custom C++ snippet `cp`)

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
`bash`, `fish`, `lua`, `luadoc`, `markdown`, `printf`, `toml`, `vim`, `vimdoc`, `yaml`.

Enable more by adding to the list. Remove a language by deleting it.

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
## 19. License
See `LICENSE` in the repository.

---
Happy hacking! Customize boldly—this setup is purposely minimal so you can grow it organically.
