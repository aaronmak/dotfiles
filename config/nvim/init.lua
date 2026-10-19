if vim.fn.has("nvim-0.12") == 0 then
	error("This configuration requires Neovim 0.12 or newer (vim.pack).")
end

require("config.options")
require("config.pack").setup()
require("plugins.display").setup()
require("plugins.coding").setup()
require("plugins.treesitter").setup()
require("plugins.editor").setup()
require("plugins.markdown").setup()
require("plugins.lsp").setup()
require("config.format").setup()
require("plugins.vim-tmux-navigator").setup()
require("config.autocmds")
require("config.keymaps")
