# Neovim Config — v12 Branch

> **Neovim 0.12+ config** — lean, plugin-managed via the new built-in `vim.pack` API (no Lazy.nvim).  
> This branch is a clean-slate rewrite targeting Neovim 0.12 nightly.  
> The `main` branch contains the older NvChad v2.5 config.

---

## 📋 Prerequisites

| Requirement | Notes |
|---|---|
| **Neovim ≥ 0.12 nightly** | Uses `vim.pack` (built-in package manager) |
| **Git** | For cloning / plugin management |
| **A Nerd Font** | For icons (e.g. [JetBrainsMono Nerd Font](https://www.nerdfonts.com/)) |
| **A C compiler** | For Treesitter parsers |
| **Optional**: `ripgrep`, `fd` | For Snacks picker / grep |

---

## 📦 Installation

```bash
# Back up existing config (if any)
mv ~/.config/nvim ~/.config/nvim.bak

# Clone this branch
git clone -b v12 https://github.com/samonide/nvim.git ~/.config/nvim

# Launch Neovim — plugins will auto-install on first start
nvim
```

Or, to test without replacing your current config:

```bash
git clone -b v12 https://github.com/samonide/nvim.git ~/.config/nvim-v12
NVIM_APPNAME=nvim-v12 nvim
```

---

## 🗂️ Project Structure

```
~/.config/nvim/
├── init.lua                  # Entry point
├── nvim-pack-lock.json       # Plugin lock file
├── after/
│   └── ftplugin/             # Filetype-specific settings
├── lsp/                      # LSP server configs (one file per server)
│   ├── clangd.lua
│   ├── lua_ls.lua
│   ├── gopls.lua
│   └── ...
├── lua/
│   ├── auto_plugin_init.lua  # Auto-sources all plugin init files
│   └── core/
│       ├── init.lua          # Loads core modules
│       ├── keymaps.lua       # All keybinds
│       ├── options.lua       # Neovim options
│       ├── autocommands.lua  # Autocommands
│       ├── utils.lua         # Helper utilities
│       └── lsp/
│           ├── init.lua      # LSP setup entry
│           ├── lspconfig.lua # LSP server launcher
│           ├── confom.lua    # Conform (formatting)
│           └── treesitter.lua
│   └── plugins/              # Plugin configs (auto-sourced)
│       ├── blink.lua         # Completion (blink.cmp)
│       ├── breadcrumbs.lua   # Breadcrumb nav
│       ├── gitsigns.lua      # Git gutter signs
│       ├── harpoon.lua       # Harpoon file marks
│       ├── kulala.lua        # HTTP client
│       ├── lazydev.lua       # Lua dev tools
│       ├── lualine.lua       # Status line
│       ├── mason.lua         # LSP/tool installer
│       ├── neogit.lua        # Git UI
│       ├── neotree.lua       # File explorer
│       ├── oil.lua           # Buffer-based file manager
│       ├── tabscope.lua      # Tab-scoped buffers
│       ├── colorscheme/      # Theme configs (Catppuccin)
│       ├── mini/             # mini.nvim modules
│       │   ├── key_clue.lua  # Which-key equivalent
│       │   ├── mini_ai.lua   # Extended text objects
│       │   ├── pick.lua      # mini.pick fuzzy finder
│       │   ├── surround.lua  # Surround motions
│       │   └── tabline.lua   # Tabline
│       └── snacks/           # Snacks.nvim modules
│           ├── init.lua      # Snacks setup
│           ├── indent.lua    # Indent guides
│           ├── keymaps.lua   # Snacks-based keymaps
│           ├── picker.lua    # File picker config
│           └── terminal.lua  # Terminal config
└── snippets/                 # JSON snippets
```

---

## ⌨️ Essential Keybinds

**Leader key: `<Space>`**

### Navigation & Files
| Key | Action |
|---|---|
| `<leader>sf` | Find files (Snacks) |
| `<leader>sg` | Live grep |
| `<leader>sb` | Find open buffers |
| `<leader>s.` | Recent files |
| `<leader>sk` | Search keymaps |
| `<leader>sh` | Search help pages |
| `<leader>sn` | Find config files |

### Harpoon (File Marks)
| Key | Action |
|---|---|
| `ma` | Add file to harpoon |
| `ml` | Open harpoon menu |
| `g1` – `g7` | Jump to harpoon slot 1–7 |

### Buffers
| Key | Action |
|---|---|
| `[b` / `]b` | Prev / next buffer |
| `<C-Tab>` / `<C-S-Tab>` | Cycle buffers |
| `<leader>bd` | Delete buffer |
| `<leader>bo` | Close all other buffers |
| `<leader>bb` / `` <leader>` `` | Switch to last buffer |

### Windows & Splits
| Key | Action |
|---|---|
| `<C-h/j/k/l>` | Navigate splits |
| `<leader>-` | Horizontal split |
| `<leader>\|` | Vertical split |
| `<leader>sv` / `sh` | vsplit / split |
| `<leader>se` | Equalize split sizes |
| `<leader>sx` | Close split |
| `<C-Arrow>` | Resize splits |
| `<leader>wd` | Delete window |

### LSP
| Key | Action |
|---|---|
| `K` | Hover documentation |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | References |
| `gI` | Go to implementation |
| `<leader>ca` | Code actions |
| `<leader>cr` / `rn` | Rename symbol |
| `<leader>cf` | Format document |
| `<leader>ls` | LSP info |
| `<leader>lr` | Restart LSP |
| `<leader>cd` | Line diagnostics float |
| `]d` / `[d` | Next / prev diagnostic |
| `]e` / `[e` | Next / prev error |

### Git
| Key | Action |
|---|---|
| `<leader>lg` | LazyGit |
| `<leader>gb` | Git blame line |
| `gX` | Open file on remote |

### Terminal
| Key | Action |
|---|---|
| `<M-i>` | Toggle floating terminal |
| `<C-x>` | Exit terminal mode |

### Tabs
| Key | Action |
|---|---|
| `<leader>to` | New tab |
| `<leader>tk` | Close tab |
| `]t` / `[t` | Next / prev tab |
| `<leader>tf` | Open current file in new tab |

### Misc
| Key | Action |
|---|---|
| `<leader>w` | Save |
| `<leader>wa` | Save all |
| `<leader>q` | Quit window |
| `<leader>qq` / `Q` | Quit all |
| `<leader>fn` | New file |
| `jk` | Exit insert mode |
| `;` | Enter command mode |
| `<leader>d` | Delete to void register |
| `<leader>p` | Paste without yanking |
| `<CR>` / `<S-CR>` | Add line below / above |

---

## 🔌 Plugins

| Plugin | Purpose |
|---|---|
| [blink.cmp](https://github.com/Saghen/blink.cmp) | Completion engine |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP client configs |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | LSP/DAP/linter installer |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Formatting |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | Picker, terminal, git browse, notifier, indent guides |
| [harpoon](https://github.com/ThePrimeagen/harpoon) | File marks & quick navigation |
| [mini.nvim](https://github.com/echasnovski/mini.nvim) | AI text objects, surround, key-clue, tabline |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | File explorer |
| [oil.nvim](https://github.com/stevearc/oil.nvim) | Buffer-based file manager |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git gutter |
| [neogit](https://github.com/NeogitOrg/neogit) | Git UI |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Status line |
| [catppuccin](https://github.com/catppuccin/nvim) | Colorscheme |
| [kulala.nvim](https://github.com/mistweaverco/kulala.nvim) | HTTP client (REST) |
| [lazydev.nvim](https://github.com/folke/lazydev.nvim) | Lua dev completions |
| [tabscope.nvim](https://github.com/tiagovla/scope.nvim) | Tab-scoped buffers |

---

## 🛠️ Adding an LSP Server

1. Install the server via Mason: `:MasonInstall <server>`
2. Create `lsp/<server_name>.lua` following the pattern of existing files

---

## ♻️ Updating

```bash
# Update config
cd ~/.config/nvim && git pull

# Plugin updates are managed via vim.pack — run inside Neovim:
# :help vim.pack
```

---

## 📜 License

MIT — see the `main` branch for more details.
