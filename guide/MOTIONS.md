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
