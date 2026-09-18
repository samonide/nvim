# Neovim Config Manual

Standalone lazy.nvim setup (no distro). Leader is `Space`.
Keybind bible: [MOTIONS.md](./MOTIONS.md). Snippets: [SNIPPETS.md](./SNIPPETS.md).

## First run

1. `nvim`, wait for plugins to install.
2. Press `Space`, wait a beat — WhichKey shows everything.
3. `<Space>fk` searches all keymaps. `<Space>?` shows them all at once.

## Daily workflow

- **Files**: `<Space>ff` find, `<Space>fg` grep, `<Space>e` tree, `<Space>ha` pin to harpoon, `<Space>1-4` jump back.
- **Code**: `gd` definition, `gr` references, `K` hover, `<Space>rn` rename, `<Space>ca` actions.
- **Check**: `[d` / `]d` hop diagnostics, `<Space>td` opens the Trouble list.
- **Format/lint**: conform formats on save; nvim-lint runs on write. `<Space>fm` formats now.

## Competitive programming

New `main.cpp` → type `cp`, Tab → full template (`cb` for the small one).
`<Space>cr` runs it, `<Space>ci` feeds `input.txt`, `<Space>ctt` runs
everything in `tests/`, `<Space>tc` shows complexity. Snippet catalog:
[SNIPPETS.md](./SNIPPETS.md).

## Terminals

- `<Space>ft` floating terminal (works from normal and terminal mode).
- `<Space>tn` opens a second one.
- Inside: `Esc Esc` drops to normal mode, `Esc` again closes the float.
- `<Space>h` / `<Space>v` split terminals, `<A-h>` / `<A-v>` toggle them.
- `<Space>ts` flips the shell between zsh and fish.

## Agent sidebar

`<Space>ap` toggles pi (`<Space>aP` in a new tab). Requires the `pi`
CLI on `$PATH`. `<Space>cd` toggles Discord presence (on by default).

## Messages & errors

Notifications go through noice, not `:messages`:

- `<Space>N` or `:Noice` — full history
- `:Noice errors` — errors only
- `:Noice last` — replay the last one
- `:Noice dismiss` — clear them all

## Theme

Caelestia owns it. Change the wallpaper and Neovim re-themes live —
editor, statusline, all of it. `<Space>th` re-applies by hand if needed.
There is no picker and no theme files to edit.

## Files & where things go

```
init.lua              bootstrap + startup order
lua/options.lua       editor options (4-space indent, clipboard, …)
lua/mappings.lua      every keymap, each with a desc
lua/plugins/init.lua  plugin specs (lazy.nvim)
lua/configs/          one module per plugin
lua/configs/servers.lua   the one LSP list mason + lspconfig share
colors/caelestia.lua  colorscheme, watches scheme.json
```

Rules that keep this config sane:

1. **Every keymap gets a `desc`** — no desc, no merge. WhichKey is the UI.
2. **No prefix collisions** — a bare `<Space>xy` plus `<Space>xyz` means the
   short one waits and popups eat keystrokes. Use a fresh letter instead
   (that's why save-all is `<Space>W`, not `<Space>wa`).
3. **One file per plugin** in `configs/`, wired from `plugins/init.lua`.
4. **Pin versions** — `lazy-lock.json` is committed. Run `:Lazy sync`
   deliberately, then commit the lockfile with it.

## Adding things

**LSP server** — append to `lua/configs/servers.lua`, restart. Mason
installs it, lspconfig starts it. Per-server tweaks go in
`lua/configs/lspconfig.lua` via `vim.lsp.config`.

**Formatter/linter** — `configs/conform.lua` (`formatters_by_ft`),
`configs/lint.lua` (`linters_by_ft`). Names must match Mason packages
for auto-install.

**Keymap** — `lua/mappings.lua`, with `desc`, checking rule 2 above.
Buffer-local LSP keys belong in `configs/lsp_helpers.lua` `on_attach`,
not in mappings.

**Plugin** — spec in `lua/plugins/init.lua` with a lazy trigger
(`event`, `cmd`, `keys`, or `ft` — never eager unless startup needs it),
config in `lua/configs/<name>.lua`. Then `:Lazy sync`.

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| blank highlighting | `:TSInstall <lang>` |
| LSP silent | `:LspInfo`, then `:Mason` to install the server |
| formatter skipped | `:lua print(vim.bo.filetype)`, check `formatters_by_ft` |
| tofu boxes | terminal font must be a Nerd Font |
| startup error flash | `<Space>N`, read it at leisure |
| keys feel stuck | you typed a prefix slowly — check WhichKey, or `:Noice last` |
| plugin misbehaving | `:Lazy sync`, restart |

Never run `:Lazy clean` here — the plugin directory on this machine is
shared with other setups and clean would delete their plugins.

---
Navigation: [Snippets](./SNIPPETS.md) · [Motions](./MOTIONS.md)
