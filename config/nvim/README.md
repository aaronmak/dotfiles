# Neovim

Standalone Neovim configuration using **Neovim 0.12+** and its built-in `vim.pack` package manager.

## Requirements and installation

- Neovim 0.12 or newer, Git, `rg` and `fzf`.
- A Nerd Font for icons; a system clipboard provider for clipboard shortcuts.
- For parser installation: Tree-sitter CLI 0.26.1+, a C compiler, `curl` and `tar`.
- Language servers and formatters managed through Mason or installed on `PATH`.
- Terraform and Packer executables for Terraform/HCL formatting and validation.

This repository uses individual symlinks. Link `init.lua`, `nvim-pack-lock.json` and each Lua file into matching locations under `~/.config/nvim/` (the root Rake task also installs other dotfiles). Include new Lua files when deploying updates.

The first startup asks before installing missing plugins recorded in `nvim-pack-lock.json`. The lockfile records exact revisions; the manifest in `lua/config/pack.lua` defines the branches followed by updates.

Run `:ToolsInstall` to install the configured Mason language servers and tools, and `:ParsersInstall` to install syntax parsers. These are explicit network/build operations, not automatic startup updates. Markdown Preview downloads its browser-preview backend on package installation/update; rebuild it with `:call mkdp#util#install()` if needed.

## Package maintenance

Run `:checkhealth vim.pack` to check the lockfile, installed revisions and inactive packages.

```vim
" Download updates and review them. :write accepts; :quit rejects.
:lua vim.pack.update()

" Reconcile installed revisions with a restored/pulled lockfile; review as above.
:lua vim.pack.update(nil, { target = 'lockfile' })

" List managed packages and their active state.
:lua vim.print(vim.pack.get())
```

After an update, restart Neovim. Run `:TSUpdate` when updating Treesitter to rebuild installed parsers. Both Treesitter packages track `main`.

To add a plugin, add its source and branch to `lua/config/pack.lua`, then configure it in a setup module. Setup order and build hooks are explicit. To remove a plugin, remove its manifest entry and setup, restart, then delete its managed installation with `:lua vim.pack.del({ 'plugin-name' })`. Commit native lockfile changes along with configuration changes.

## Layout

- `lua/config/pack.lua`: package manifest and build hooks.
- `lua/config/options.lua`, `autocmds.lua`, `keymaps.lua`: editor defaults and shortcuts.
- `lua/config/root.lua`, `format.lua`, `buffers.lua`, `files.lua`: shared helpers.
- `lua/plugins/`: Lua setup modules, explicitly called by `init.lua`.

## Features

- Fzf-lua file/search pickers, tmux-aware navigation and Git hunk tools.
- Completion with native snippets, structural text objects, contextual comments and surround editing.
- LSP, formatting and linting for Lua, Python, shell, Terraform/HCL, TOML, JSON, YAML and Markdown.
- JSON/YAML schemas, Markdown rendering and browser preview.
- Tokyo Night, Bufferline, Lualine, Vimade, Which-key, Noice and session persistence.
- Mini Icons for icons and devicons compatibility.
- Snacks dashboard, indent guides, smooth scrolling, notifications, quick-file display and large-file handling.

## Shortcuts

Space is the leader.

| Shortcut | Action |
| --- | --- |
| `<leader><space>`, `<leader>ff` | Find project files |
| `<leader>/`, `<leader>sg` | Search project text |
| `<leader>,`, `<leader>fb` | Find buffers |
| `<leader>sr` | Project search/replace |
| `<C-h/j/k/l>` | Navigate splits and tmux panes |
| `<leader><C-h/j/k/l>` | Move to a split or create one |
| `<Tab>`, `<S-Tab>` | Next/previous buffer |
| `<leader>bq`, `<leader>bqa`, `<leader>bqq` | Close current/all/other buffers safely |
| `<C-s>` | Save |
| `gd`, `gr`, `gI`, `gy`, `K` | LSP definition/references/implementations/types/hover |
| `<leader>ca`, `<leader>cr` | Code action / rename symbol |
| `<leader>cf` | Format |
| `<leader>uf`, `<leader>uF` | Toggle global/buffer autoformat |
| `gc`, `gcc` | Comment selection / line |
| `gsa`, `gsd`, `gsr` | Add/delete/replace surrounding delimiters |
| `<leader>gh…` | Git hunk actions (see Which-key) |
| `<leader>cp` | Toggle browser Markdown preview |
| `<leader>qs`, `<leader>qS` | Restore current session / select session |
| `<leader>ql`, `<leader>qd` | Restore last session / stop session saving |
| `<leader>co`, `<leader>fy` | Copy whole file / relative path |
| `<leader>rf`, `<leader>dcf` | Rename/delete file with validation and confirmation |

Normal `j`/`k` move by screen lines. File rename/delete require saved buffers; buffer closing never silently discards edits. Prose wraps and spellchecks; code does not wrap. Saving removes trailing whitespace except in Markdown, where spaces can represent hard line breaks.
