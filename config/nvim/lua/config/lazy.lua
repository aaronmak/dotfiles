-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- =======================
-- Settings
-- =======================

vim.opt.encoding = "utf8" -- Set utf8 as standard encoding and en_US as the standard language
vim.opt.ffs = "unix,dos,mac" -- Use Unix as the standard file type
vim.opt.hidden = true -- Allow buffer change w/o saving
vim.opt.so = 7 -- Set 7 lines to the cursor - when moving vertically using j/k
vim.opt.cmdheight = 3 -- Height of the command bar
vim.opt.updatetime = 300 -- Reduce update time from default of 4000
vim.opt.autoread = true -- Auto read when a file is changed from elsewhere
vim.opt.ignorecase = true -- Ignore case when searching
vim.opt.smartcase = true -- When searching try to be smart about cases
vim.opt.incsearch = true -- Makes search act like search in modern browsers
vim.opt.lazyredraw = true -- Don't redraw while executing macros (good performance config)
vim.opt.magic = true -- For regular expressions turn magic on
vim.opt.showmatch = true -- Show matching brackets when text indicator is over them
vim.opt.mat = 2 -- How many tenths of a second to blink when matching brackets
vim.opt.foldcolumn = "1" -- Add a bit extra margin to the left
vim.opt.relativenumber = true -- Set relative line numbers
vim.opt.number = true -- Set line numbers
vim.opt.scrolloff = 4 -- Keep at least 4 lines below cursor
vim.opt.signcolumn = "yes" -- always show signcolumns
vim.opt.grepprg = "rg" --vimgrep   -- Use RipGrep instead of grep
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.swapfile = false -- Disable swap files since there's version control

vim.opt.timeoutlen = 500

vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smarttab = true -- Be smart when using tabs

-- 1 tab == 2 spaces
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.shiftround = true -- When at 3 spaces and I hit >>, go to 4, not 5.

-- Linebreak on 500 characters
vim.opt.linebreak = true
vim.opt.textwidth = 500
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = true -- Wrap lines

-- Spelling for Markdown and gitcommits
vim.api.nvim_command([[
augroup markdownSpell
  autocmd FileType gitcommit setlocal spell
  autocmd FileType markdown setlocal spell
augroup END
]])

vim.cmd("syntax enable")
vim.opt.hlsearch = true
vim.opt.termguicolors = true

-- Disable netrw
vim.g.loaded_netrwPlugin = 1

-- Paste (requires xsel installed)
vim.opt.clipboard = "unnamedplus"

-- Ignore compiled files
vim.opt.wildignore = "*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store"

vim.opt.completeopt = "menu,menuone,noselect"

-- Remove trailing whitespaces
vim.cmd("autocmd BufWritePre * :%s/s+$//e")

-- Do not continue comment on new line
vim.cmd("autocmd BufNewFile,BufRead * setlocal formatoptions-=cro")

vim.g.python3_host_prog = "$HOME/.virtualenvs/neovim/bin/python"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
		{ import = "lazyvim.plugins.extras.coding.mini-comment" },
		{ import = "lazyvim.plugins.extras.coding.mini-surround" },
		{ import = "lazyvim.plugins.extras.coding.neogen" },
		{ import = "lazyvim.plugins.extras.coding.nvim-cmp" },
		{ import = "lazyvim.plugins.extras.editor.illuminate" },
		{ import = "lazyvim.plugins.extras.editor.navic" },
		{ import = "lazyvim.plugins.extras.lang.git" },
		{ import = "lazyvim.plugins.extras.lang.json" },
		{ import = "lazyvim.plugins.extras.lang.markdown" },
		{ import = "lazyvim.plugins.extras.lang.python" },
		{ import = "lazyvim.plugins.extras.lang.java" },
		{ import = "lazyvim.plugins.extras.lang.terraform" },
		{ import = "lazyvim.plugins.extras.lang.toml" },
		{ import = "lazyvim.plugins.extras.lang.yaml" },
		{ import = "lazyvim.plugins.extras.test.core" },
		{ import = "lazyvim.plugins.extras.util.dot" },
		{ import = "lazyvim.plugins.extras.util.mini-hipatterns" },
		{ import = "plugins" },
	},
	defaults = {
		lazy = false,
		version = false,
	},
	install = { colorscheme = { "tokyonight" } },
	checker = {
		enabled = true,
		notify = false, -- notify on update
	},
})
