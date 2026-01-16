# Neovim Motions & Operators (Beginner Cheat Sheet)

A compact reference of the most useful NORMAL mode motions & operators for someone new to Vim/Neovim. Combine them: `operator + motion` (e.g. `daw`, `ci(`, `y2j`).

## Legend
- `{count}` = optional number (e.g. `3w`)
- `[]` = placeholder (don’t type the brackets)
- `object` = text object like `w`, `aw`, `i"`, `a(`

## Basic Cursor
| Key | Action |
|-----|--------|
| `h` `j` `k` `l` | Left / Down / Up / Right |
| `{count}j` / `{count}k` | Move multiple lines |
| `0` | Start of line |
| `^` | First non-blank |
| `$` | End of line |
| `gg` / `G` | File start / end |
| `{count}G` | Go to line `{count}` |
| `:linenumber` | Also go to a specific line |

## Word Motions
| Key | Action |
|-----|--------|
| `w` / `b` | Next / previous word start |
| `e` / `ge` | Next / previous word end |
| `W` / `B` | WORD (space-delimited) start forward/back |
| `E` / `gE` | WORD end forward/back |

## Find / Search Inline
| Key | Action |
|-----|--------|
| `f{char}` / `F{char}` | Jump to next / prev occurrence of `{char}` on line |
| `t{char}` / `T{char}` | Jump before (`t`) or after (`T`) char |
| `;` / `,` | Repeat last f/t forward / backward |
| `%` | Jump to matching `()[]{}` pair |

## Global Search
| Key | Action |
|-----|--------|
| `/pattern` | Forward search |
| `?pattern` | Backward search |
| `n` / `N` | Next / previous match |
| `*` / `#` | Search word under cursor forward / backward |

## Scrolling / View
| Key | Action |
|-----|--------|
| `<C-u>` / `<C-d>` | Half-page up / down |
| `<C-b>` / `<C-f>` | Full page up / down |
| `zz` | Center cursor line |
| `zt` / `zb` | Cursor line to top / bottom |

## Insertion
| Key | Action |
|-----|--------|
| `i` / `a` | Insert before / after cursor |
| `I` / `A` | Insert at line start / end |
| `o` / `O` | New line below / above |
| `gi` | Re‑enter last insert position |

## Operators
| Key | Action |
|-----|--------|
| `d` | Delete (cuts) motion or text object |
| `c` | Change (delete then insert) |
| `y` | Yank (copy) |
| `g~` | Toggle case motion |
| `gu` / `gU` | Lower / upper case motion |
| `>` / `<` | Indent / dedent motion |
| `=` | Re-indent motion |
| `!` | Filter through external command |

Combine with motions: examples: `dw`, `ci"`, `yap`, `gUw`.

## Text Objects (use with operators or `v`)
| Object | Scope |
|--------|-------|
| `iw` / `aw` | Inner / a word |
| `iW` / `aW` | Inner / a WORD |
| `is` / `as` | Inner / a sentence |
| `ip` / `ap` | Inner / a paragraph |
| `i"` / `a"` | Inside / around quotes (any quoting char) |
| `i'` / `a'` | Inside / around single quotes |
| `i(` / `a(` | Inside / around parentheses (also works with `[] {}`) |
| `i{` / `a{` | Inside / around braces |
| `i[` / `a[` | Inside / around brackets |
| `i<` / `a<` | Inside / around angle brackets |
| `it` / `at` | Inside / around XML/HTML tag (requires matchit plugin or Treesitter) |

## Visual Mode
| Key | Action |
|-----|--------|
| `v` | Character-wise visual |
| `V` | Line-wise visual |
| `<C-v>` | Block / column visual |
| `o` | Jump to other end of selection |
| `gv` | Reselect last visual selection |

## Marks & Jumps
| Key | Action |
|-----|--------|
| `m{a-z}` | Set mark `{a-z}` in file |
| `'{a-z}` / `` `{a-z}` `` | Jump to mark line / exact position |
| `` `` `` | Jump back to last jump position |
| `''` | Jump back to last line (same file) |
| `{` / `}` | Previous / next paragraph |

## Registers
| Key | Action |
|-----|--------|
| `""` | Unnamed (default) register |
| `"0` | Last yank |
| `"1`..`"9` | Delete history registers |
| `"a`..`"z` | Named registers |
| `"+` / `"*` | System clipboard (+ often = *) |
| `"_` | Black hole (discard) |

Use: `"+p` paste system clipboard, `"_daw` delete word without yanking.

## Undo / Redo
| Key | Action |
|-----|--------|
| `u` | Undo |
| `<C-r>` | Redo |
| `U` | (Deprecated) restore last changed line |

## Buffers / Windows / Tabs
| Key | Action |
|-----|--------|
| `:bnext` / `:bprev` | Cycle buffers |
| `:bd` | Delete buffer |
| `:sp` / `:vsp` | Horizontal / vertical split |
| `<C-w>h/j/k/l` | Move between windows |
| `<C-w>q` | Close window |
| `:tabnew` | New tab |
| `gt` / `gT` | Next / previous tab |

## Macro Basics
| Key | Action |
|-----|--------|
| `q{a-z}` | Start recording macro to register |
| `q` | Stop recording |
| `@{a-z}` | Play macro |
| `@@` | Repeat last macro |

## Useful Combos
| Combo | Result |
|-------|--------|
| `ci(` | Change inside parentheses |
| `yi"` | Yank inside quotes |
| `dap` | Delete a paragraph |
| `vit` | Select inside HTML tag |
| `:%s/old/new/g` | Substitute all occurrences |
| `:%!sort` | Replace buffer with its sorted version |

## Learning Strategy
1. Master motions before plugins – speed comes from core.
2. Practice operator+motion combos deliberately.
3. Gradually add text objects (quotes, brackets, tags).
4. Use `.` to repeat the last change efficiently.
5. Use marks when jumping between far code regions.

---
For deeper reference: `:h motion.txt`, `:h operator`, `:h text-objects`.

---
Navigation: [User Manual](./USERMANUAL.md) · [Snippets](./SNIPPETS.md)

---

# Neovim Configuration Keybinds Cheatsheet

> **Leader key**: `Space` | **Local leader**: `\`

---

## 🚀 Core Essentials

| Key | Mode | Action | Description |
|-----|------|--------|-------------|
| `;` | Normal | `:` | Enter command mode |
| `jk` | Insert | `<ESC>` | Exit insert mode |
| `<leader>w` | Normal | Save | Write current buffer |
| `<leader>q` | Normal | Quit | Quit current window |
| `<leader>Q` | Normal | Quit All | Quit all windows |
| `<leader>wa` | Normal | Save All | Write all buffers |
| `<leader>qq` | Normal | Quit All | Quit all (shortcut) |
| `<Esc>` | Normal | Clear Highlight | Clear search highlighting |
| `<leader>nh` | Normal | No Highlight | Clear search highlight |

---

## 📂 Buffer Management

| Key | Mode | Action |
|-----|------|--------|
| `<leader>bd` | Normal | Delete current buffer |
| `<leader>bn` | Normal | Next buffer |
| `<leader>bp` | Normal | Previous buffer |
| `<leader>ba` | Normal | Close all buffers except current |
| `<Tab>` | Normal | Next buffer (quick) |
| `<S-Tab>` | Normal | Previous buffer (quick) |

---

## 🪟 Window/Split Navigation & Management

### Navigation
| Key | Mode | Action |
|-----|------|--------|
| `<C-h>` | Normal | Focus left split |
| `<C-j>` | Normal | Focus down split |
| `<C-k>` | Normal | Focus up split |
| `<C-l>` | Normal | Focus right split |

### Split Creation
| Key | Mode | Action |
|-----|------|--------|
| `<leader>sv` | Normal | Vertical split |
| `<leader>sh` | Normal | Horizontal split |
| `<leader>sx` | Normal | Close current split |
| `<leader>se` | Normal | Equalize split sizes |

### Window Resizing
| Key | Mode | Action |
|-----|------|--------|
| `<C-Up>` | Normal | Increase window height |
| `<C-Down>` | Normal | Decrease window height |
| `<C-Left>` | Normal | Decrease window width |
| `<C-Right>` | Normal | Increase window width |

---

## 🔍 Telescope (Fuzzy Finder)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ff` | Normal | Find files |
| `<leader>fg` | Normal | Live grep (search text) |
| `<leader>fb` | Normal | Find buffers |
| `<leader>fh` | Normal | Help tags |
| `<leader>fo` | Normal | Recent files (oldfiles) |
| `<leader>fw` | Normal | Find word under cursor |
| `<leader>fc` | Normal | Find commands |
| `<leader>fk` | Normal | Find keymaps |
| `<leader>fs` | Normal | Document symbols (LSP) |
| `<leader>fn` | Normal | New file |

---

## 🎯 Harpoon (Quick File Marks)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ha` | Normal | Add current file to Harpoon |
| `<leader>hh` | Normal | Toggle Harpoon menu |
| `<leader>1` | Normal | Jump to Harpoon file #1 |
| `<leader>2` | Normal | Jump to Harpoon file #2 |
| `<leader>3` | Normal | Jump to Harpoon file #3 |
| `<leader>4` | Normal | Jump to Harpoon file #4 |

---

## 💻 Terminal

| Key | Mode | Action |
|-----|------|--------|
| `<A-i>` | Normal/Terminal | Toggle floating bash terminal |
| `<A-h>` | Normal | Toggle horizontal terminal |
| `<A-v>` | Normal | Toggle vertical terminal |
| `<leader>ts` | Normal | Toggle shell (zsh ↔ fish) |

---

## 🔧 LSP (Language Server Protocol)

| Key | Mode | Action |
|-----|------|--------|
| `gd` | Normal | Go to definition |
| `gD` | Normal | Go to declaration |
| `gi` | Normal | Go to implementation |
| `gr` | Normal | Show references |
| `K` | Normal | Hover documentation |
| `<leader>rn` | Normal | Rename symbol |
| `<leader>ca` | Normal | Code actions |
| `<leader>lf` | Normal | Format document |
| `<leader>ls` | Normal | LSP info |
| `<leader>lr` | Normal | Restart LSP |
| `[d` | Normal | Previous diagnostic |
| `]d` | Normal | Next diagnostic |
| `<leader>e` | Normal | Show diagnostic float |

---

## 🐛 Trouble (Diagnostics UI)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>td` | Normal | Toggle diagnostics |
| `<leader>tq` | Normal | Toggle quickfix list |
| `<leader>tr` | Normal | Toggle LSP references |

---

## 🏃 Code Runner

| Key | Mode | Action |
|-----|------|--------|
| `<leader>cr` | Normal | Run code |
| `<leader>cb` | Normal | Build only |
| `<leader>ce` | Normal | Run last build |
| `<leader>ci` | Normal | Run with input.txt |
| `<leader>ct` | Normal | Run in floating terminal |
| `<leader>ctt` | Normal | Run all tests |
| `<leader>co` | Normal | Cycle optimization profile |
| `<leader>cw` | Normal | Toggle watch mode |
| `<leader>ch` | Normal | Show run history |
| `<leader>cc` | Normal | Clean build directory |
| `<C-A-n>` | Normal | Run with input.txt → output.txt |

---

## 📊 Timesense (Complexity Analysis)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>tc` | Normal | Complexity analysis |
| `<leader>tx` | Normal | Coding stats |

---

## 🔀 Git Integration

| Key | Mode | Action |
|-----|------|--------|
| `<leader>gd` | Normal | Open diff view |
| `<leader>gh` | Normal | Git file history |
| `<leader>gH` | Normal | Git branch history |
| `<leader>gs` | Normal | Git status (Telescope) |
| `<leader>gc` | Normal | Git commits (Telescope) |
| `<leader>gb` | Normal | Git branches (Telescope) |

---

## 📝 Editing Enhancements

### Visual Mode Operations
| Key | Mode | Action |
|-----|------|--------|
| `<` | Visual | Indent left (stay in visual) |
| `>` | Visual | Indent right (stay in visual) |
| `J` | Visual | Move selection down |
| `K` | Visual | Move selection up |

### Enhanced Navigation
| Key | Mode | Action |
|-----|------|--------|
| `j` | Normal | Move down (wrap-aware) |
| `k` | Normal | Move up (wrap-aware) |
| `n` | Normal | Next search (centered) |
| `N` | Normal | Previous search (centered) |
| `<C-d>` | Normal | Half page down (centered) |
| `<C-u>` | Normal | Half page up (centered) |

### Advanced Editing
| Key | Mode | Action |
|-----|------|--------|
| `<leader>p` | Visual | Paste without yanking |
| `<leader>d` | Normal/Visual | Delete to void register |

---

## 💬 Comments (Comment.nvim)

| Key | Mode | Action |
|-----|------|--------|
| `gcc` | Normal | Toggle line comment |
| `gbc` | Normal | Toggle block comment |
| `gc` | Visual/Normal | Comment operator |
| `gb` | Visual/Normal | Block comment operator |

---

## 🦘 Flash (Quick Navigation)

| Key | Mode | Action |
|-----|------|--------|
| `s` | Normal/Visual/Operator | Flash jump |
| `S` | Normal/Visual/Operator | Flash treesitter |
| `r` | Operator | Remote flash |
| `R` | Operator/Visual | Treesitter search |
| `<c-s>` | Command | Toggle flash search |

---

## 📌 Todo Comments

| Key | Mode | Action |
|-----|------|--------|
| `]t` | Normal | Next todo comment |
| `[t` | Normal | Previous todo comment |

---

## 🎮 Discord Rich Presence

| Key | Mode | Action |
|-----|------|--------|
| `<leader>cd` | Normal | Toggle Discord presence |

---

## 📁 File Explorer (NvimTree)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>e` | Normal | Toggle file explorer |
| `<leader>ef` | Normal | Focus file explorer |

---

## ✂️ Snippets (LuaSnip)

| Key | Mode | Action |
|-----|------|--------|
| `<C-n>` | Insert/Select | Expand or jump forward |
| `<C-p>` | Insert/Select | Jump backward |

### Common C++ Snippets
- `cp` - Full competitive programming template
- `cb` - Simple C++ boilerplate
- `for` / `fori` - Classic for-loop
- `forr` - Range-based for-loop
- `main` - Main function template
- `fastio` - Fast I/O setup
- `defs` - Common typedefs and defines
- `dbg` - Debug macro
- `modops` - Modular arithmetic operations

---

## 🎨 Surround Operations (nvim-surround)

Default keybinds:
- `ys{motion}{char}` - Add surrounding
- `ds{char}` - Delete surrounding
- `cs{old}{new}` - Change surrounding

**Examples:**
- `ysiw"` - Surround inner word with quotes
- `ds"` - Delete surrounding quotes
- `cs"'` - Change surrounding " to '
- `yss)` - Surround entire line with ()

---

## 🎯 Quick Reference: Most Used

### Essential Daily Shortcuts
```
Navigation:       Ctrl+h/j/k/l (splits), Tab/Shift+Tab (buffers)
Finding:          Space+ff (files), Space+fg (grep), Space+fb (buffers)
Harpoon:          Space+ha (add), Space+1/2/3/4 (jump to mark)
Terminal:         Alt+i (floating)
LSP:              gd (definition), gr (references), K (hover), Space+rn (rename)
Save/Quit:        Space+w (save), Space+q (quit)
```

### Keybind Prefix System
- `<leader>f` - **F**ind/File operations (Telescope)
- `<leader>h` - **H**arpoon marks + file history
- `<leader>t` - **T**rouble/Toggle/Timesense
- `<leader>c` - **C**ode runner operations
- `<leader>g` - **G**it operations
- `<leader>l` - **L**SP operations
- `<leader>s` - **S**plit operations
- `<leader>b` - **B**uffer operations
- `<leader>e` - **E**xplorer (file tree)

### Pro Tips
1. **Muscle Memory Priority:** Learn `Ctrl+hjkl` first, then `Space+ff` and `Space+fg`, then Harpoon marks
2. **Workflow:** Mark 4 key files with `Space+ha`, jump between them with `Space+1234`
3. **When Lost:** Press `Space` and wait → WhichKey shows options, or use `Space+fk` to search keymaps
4. **Terminal:** `Alt+i` for quick commands, exit with `exit` or `Ctrl+d`
5. **Flash Navigation:** Use `s` for quick cursor jumps instead of multiple `w`/`b` motions

---

## 📚 Additional Resources

- NvChad defaults: `:NvCheatsheet`
- All keymaps: `<leader>fk` (Telescope keymaps)
- Help system: `<leader>fh` (Telescope help tags)
- Command palette: `<leader>fc` (Telescope commands)
- Vim help: `:h motion.txt`, `:h operator`, `:h text-objects`

---

**Last Updated**: January 2026  
**Config Location**: `~/.config/nvim/`
