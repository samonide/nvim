# Competitive Programming Snippets (C++)

All LuaSnip triggers defined in `lua/configs/cp_snippets.lua` plus the basic `cp` template.

> Expand snippets in insert mode by typing the trigger then pressing `<Tab>` (or your configured completion/snippet expansion key if using completion integration). Use `<C-j>` / `<C-k>` (as mapped) to jump forward/backward inside placeholders.

## Core Templates
| Trigger | Purpose |
|---------|---------|
| `cp` | Full competitive programming template (advanced: typedefs, macros, solve function, multi-test support) |
| `cb` | Simple C++ boilerplate (basic includes + main function for quick coding) |
| `main` | Flexible main (choice of include/pragma + optional multi-test) |
| `fastio` | Insert fast I/O lines |
| `hdr` | File header (author/date/contest) |
| `defs` | Common typedefs & helper macros |
| `dbg` | Debug macro `dbg(x)` guarded by `LOCAL` |

## Math / Modular
| Trigger | Purpose |
|---------|---------|
| `modops` | Add/mod/sub/mul/pow/inv helpers (choose MOD) |
| `comb` | Precompute factorials + nCr helper (needs `inv()`) |
| `matpow` | Matrix multiplication + fast exponentiation |

## Data Structures
| Trigger | Purpose |
|---------|---------|
| `dsu` | Disjoint Set Union (union-find with size) |
| `bit` | Fenwick / Binary Indexed Tree (point add / prefix / range) |
| `seg` | Segment tree (point update + range sum query) |
| `segl` | Lazy segment tree (range add + range sum) |
| `stbl` | Sparse table for RMQ (min) with query lambda |
| `v2` | 2D vector declaration with dimensions |
| `arr` | 1D vector with size |
| `bs` | Bitset declaration |

## Graph / Trees
| Trigger | Purpose |
|---------|---------|
| `bfs` | BFS skeleton with distance array |
| `dfs` | Recursive DFS lambda (tree/graph) |
| `dijk` | Dijkstra shortest path (adj list of pairs) |
| `topo` | Kahn topological sort |
| `lca` | LCA via binary lifting (root at 0) |

## Strings
| Trigger | Purpose |
|---------|---------|
| `kmp` | Prefix-function (π array) |
| `zfn` | Z-function computation |

## Sequences / Arrays
| Trigger | Purpose |
|---------|---------|
| `pref` | Prefix sum array build |
| `lis` | LIS (n log n) with reconstruction |
| `ccmp` | Coordinate compression of vector `a` |

## Number Theory
| Trigger | Purpose |
|---------|---------|
| `sieve` | Linear sieve (primes + lp array) |

## Search / Optimization
| Trigger | Purpose |
|---------|---------|
| `binans` | Binary search on answer skeleton |

## Utilities
| Trigger | Purpose |
|---------|---------|
| `rng` | Random generator + helper lambda |
| `scan` | Fast integer scanner (GNU / POSIX getchar_unlocked) |

## Usage Examples

1. **Create new C++ file**: `nvim main.cpp`
2. **Insert full template**: Type `cp` + `<Tab>` 
3. **Insert simple template**: Type `cb` + `<Tab>`
4. **Add for-loop**: Type `for` + `<Tab>` (or `fori` + `<Tab>`)
5. **Range-based loop**: Type `forr` + `<Tab>`
6. **Quick algorithm**: Type `dsu` + `<Tab>`, `seg` + `<Tab>`, etc.

### Workflow Integration
- **Compile & Run**: `<leader>cr` (interactive terminal)
- **Floating Terminal**: `<leader>ct` (overlay terminal)  
- **File I/O**: `<leader>ci` (input.txt → terminal output)
- **Silent I/O**: `<C-A-n>` (input.txt → output.txt)
- **Batch Testing**: `<leader>ctt` (tests/*.in vs tests/*.out)

## Customizing
Add or edit snippets in `lua/configs/cp_snippets.lua` then reload Neovim or run:
```:lua package.loaded["configs.cp_snippets"] = nil; require("configs.cp_snippets")```.

Happy competing! 🚀  |  [User Manual](./USERMANUAL.md) · [Motions](./MOTIONS.md)
