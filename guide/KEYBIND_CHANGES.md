# Keybind Refactoring - Changes Log

**Date:** January 16, 2026  
**Status:** ✅ Complete

---

## 🔧 Fixed Issues

### 1. **Removed Duplicate Keybinds**
- ❌ Removed: `<leader>ft` (duplicate floating terminal)
- ✅ Kept: `<A-i>` for floating terminal (more ergonomic)

### 2. **Resolved Conflicts**

#### Harpoon vs Window Navigation
- **Before:** `<leader>h` mapped to both Harpoon menu AND window navigation (CONFLICT!)
- **After:** 
  - Harpoon menu: `<leader>hh` 
  - Harpoon marks: `<leader>1`, `<leader>2`, `<leader>3`, `<leader>4` (shorter!)
  - Window navigation: `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` (Vim standard)

#### LuaSnip vs Window Navigation
- **Before:** `<C-j>` and `<C-k>` for snippet navigation (conflicted with window nav)
- **After:** 
  - Snippets: `<C-n>` (next) and `<C-p>` (previous)
  - Windows: `<C-h/j/k/l>` free for navigation

---

## ➕ Added Keybinds (40+ new shortcuts)

### Buffer Management
- `<leader>bd` - Delete buffer
- `<leader>bn` / `<leader>bp` - Next/Previous buffer
- `<leader>ba` - Close all except current
- `<Tab>` / `<S-Tab>` - Quick buffer switching

### Split Management
- `<leader>sv` / `<leader>sh` - Vertical/Horizontal split
- `<leader>sx` - Close split
- `<leader>se` - Equalize splits
- `<C-Arrow>` - Resize windows

### Telescope (Fuzzy Finder)
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Find buffers
- `<leader>fh` - Help tags
- `<leader>fo` - Recent files
- `<leader>fw` - Find word under cursor
- `<leader>fc` - Commands
- `<leader>fk` - Keymaps
- `<leader>fs` - Document symbols

### LSP Operations
- `gd` / `gD` - Definition/Declaration
- `gi` / `gr` - Implementation/References
- `K` - Hover docs
- `<leader>rn` - Rename
- `<leader>ca` - Code actions
- `<leader>lf` - Format
- `<leader>ls` / `<leader>lr` - LSP info/restart

### Git Integration
- `<leader>gs` - Git status
- `<leader>gc` - Git commits
- `<leader>gb` - Git branches

### File Explorer
- `<leader>e` - Toggle NvimTree
- `<leader>ef` - Focus NvimTree

### Quick Commands
- `<leader>nh` - Clear highlight
- `<leader>fn` - New file
- `<leader>qq` - Quit all
- `<leader>wa` - Save all

---

## 🗑️ Removed Plugins

### 1. **overseer.nvim** → Use `runner.nvim` instead
- **Reason:** Redundant for competitive programming
- **Impact:** Removed `<leader>ot` and `<leader>or` keybinds
- **Alternative:** Use `runner.nvim` keybinds (`<leader>cr`, `<leader>ci`, etc.)

### 2. **nvim-bqf** → Use `trouble.nvim` instead
- **Reason:** Trouble provides better diagnostics/quickfix UI
- **Impact:** No keybind changes (bqf had no explicit keybinds)
- **Alternative:** Use Trouble (`<leader>td`, `<leader>tq`, `<leader>tr`)

---

## 📊 Keybind Organization

All keybinds now follow a consistent prefix system:

| Prefix | Category | Examples |
|--------|----------|----------|
| `<leader>f` | Find/Files | `ff` (files), `fg` (grep), `fb` (buffers) |
| `<leader>h` | Harpoon | `ha` (add), `hh` (menu), `1-4` (marks) |
| `<leader>t` | Trouble/Toggle | `td` (diagnostics), `tq` (quickfix), `ts` (shell) |
| `<leader>c` | Code Runner | `cr` (run), `ci` (input), `cb` (build) |
| `<leader>g` | Git | `gs` (status), `gd` (diff), `gc` (commits) |
| `<leader>l` | LSP | `lf` (format), `ls` (info), `lr` (restart) |
| `<leader>s` | Splits | `sv` (vertical), `sh` (horizontal), `sx` (close) |
| `<leader>b` | Buffers | `bd` (delete), `bn` (next), `bp` (previous) |
| `<leader>e` | Explorer | `e` (toggle), `ef` (focus) |

---

## 📝 Documentation

All keybinds are now documented in [MOTIONS.md](./MOTIONS.md), which includes:
- ✅ Vim motion fundamentals
- ✅ Custom keybind configurations
- ✅ Plugin-specific shortcuts
- ✅ Quick reference tables
- ✅ Pro tips and workflow suggestions

---

## 🎯 Quick Start

**Most Used Keybinds:**
```
Space + f f      → Find files
Space + f g      → Search in files
Space + 1-4      → Jump to Harpoon marks
Ctrl + h/j/k/l   → Navigate splits
Tab / Shift+Tab  → Next/Previous buffer
Alt + i          → Floating terminal
g d              → Go to definition
K                → Hover docs
Space + c r      → Run code
```

**When you forget:**
- Press `Space` and wait → WhichKey popup
- Or use `Space + f k` → Search all keymaps

---

## ✅ Verification

- [x] No syntax errors in config files
- [x] All `overseer` references removed
- [x] All `nvim-bqf` references removed
- [x] No duplicate keybinds
- [x] No conflicting keybinds
- [x] Documentation merged into [MOTIONS.md](./MOTIONS.md)
- [x] Standalone markdown files cleaned up

---

**Status:** Ready to use! Restart Neovim to apply changes.
