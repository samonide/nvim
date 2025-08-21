# Competitive Programming Snippets (C++)

All LuaSnip triggers defined in `lua/configs/cp_snippets.lua` plus the basic `cp` template.

> Expand snippets in insert mode by typing the trigger then pressing `<Tab>` (or your configured completion/snippet expansion key if using completion integration). Use `<C-j>` / `<C-k>` (as mapped) to jump forward/backward inside placeholders.

## Core Templates
| Trigger | Purpose |
|---------|---------|
| `cp` | Full minimal contest template (fast I/O + loop) |
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

## Usage Notes
1. Some snippets assume variables: `n`, `g` (adjacency), `a` (array), `MOD` defined externally.
2. `comb` requires an `inv()` modular inverse (already provided by `modops`). Expand `modops` first or adapt.
3. `lca` expects `g` as `vector<vector<int>>` and builds from root `0`; adjust as needed.
4. `dijk` assumes `g[v]` holds `pair<int,long long>` (to, weight); adapt for other weight types.
5. `LOCAL` debug macro: compile with `-DLOCAL` to enable `dbg(x)` prints.
6. For very large constraints, consider adding custom allocators or iterative DFS to avoid stack limits.

## Customizing
Add or edit snippets in `lua/configs/cp_snippets.lua` then reload Neovim or run:
```:lua package.loaded["configs.cp_snippets"] = nil; require("configs.cp_snippets")```.

Happy competing! 🚀  |  [User Manual](./USERMANUAL.md) · [Motions](./MOTIONS.md)
