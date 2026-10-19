local M = {}

M.specs = {
	{ src = "https://github.com/nvim-lua/plenary.nvim", version = "master" },
	{ src = "https://github.com/MunifTanjim/nui.nvim", version = "main" },
	{ src = "https://github.com/nvim-mini/mini.icons", version = "main" },
	{ src = "https://github.com/folke/tokyonight.nvim", version = "main" },
	{ src = "https://github.com/folke/snacks.nvim", version = "main" },
	{ src = "https://github.com/akinsho/bufferline.nvim", version = "main" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim", version = "master" },
	{ src = "https://github.com/TaDaa/vimade", version = "master" },
	{ src = "https://github.com/folke/which-key.nvim", version = "main" },
	{ src = "https://github.com/folke/noice.nvim", version = "main" },
	{ src = "https://github.com/rafamadriz/friendly-snippets", version = "main" },
	{ src = "https://github.com/hrsh7th/nvim-cmp", version = "main" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp", version = "main" },
	{ src = "https://github.com/hrsh7th/cmp-buffer", version = "main" },
	{ src = "https://github.com/hrsh7th/cmp-path", version = "main" },
	{ src = "https://github.com/garymjr/nvim-snippets", version = "main" },
	{ src = "https://github.com/nvim-mini/mini.ai", version = "main" },
	{ src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring", version = "main" },
	{ src = "https://github.com/nvim-mini/mini.comment", version = "main" },
	{ src = "https://github.com/nvim-mini/mini.surround", version = "main" },
	{ src = "https://github.com/nvim-mini/mini.hipatterns", version = "main" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
	{ src = "https://github.com/windwp/nvim-ts-autotag", version = "main" },
	{ src = "https://github.com/ibhagwan/fzf-lua", version = "main" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim", version = "main" },
	{ src = "https://github.com/RRethy/vim-illuminate", version = "master" },
	{ src = "https://github.com/folke/todo-comments.nvim", version = "main" },
	{ src = "https://github.com/MagicDuck/grug-far.nvim", version = "main" },
	{ src = "https://github.com/folke/persistence.nvim", version = "main" },
	{ src = "https://github.com/christoomey/vim-tmux-navigator", version = "master" },
	{ src = "https://github.com/mason-org/mason.nvim", version = "main" },
	{ src = "https://github.com/neovim/nvim-lspconfig", version = "master" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim", version = "main" },
	{ src = "https://github.com/b0o/SchemaStore.nvim", version = "main" },
	{ src = "https://github.com/stevearc/conform.nvim", version = "master" },
	{ src = "https://github.com/mfussenegger/nvim-lint", version = "master" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim", version = "main" },
	{ src = "https://github.com/iamcco/markdown-preview.nvim", version = "master" },
}

function M.setup()
	vim.api.nvim_create_autocmd("PackChanged", {
		group = vim.api.nvim_create_augroup("NativePackageBuilds", { clear = true }),
		callback = function(event)
			local change = event.data
			if change.kind == "delete" then
				return
			end
			if change.spec.name == "markdown-preview.nvim" then
				vim.cmd.packadd("markdown-preview.nvim")
				vim.fn["mkdp#util#install"]()
			elseif change.kind == "update" and change.spec.name == "nvim-treesitter" then
				vim.schedule(function()
					vim.notify("Treesitter updated: restart Neovim, then run :TSUpdate to rebuild parsers")
				end)
			end
		end,
	})

	-- Native packages have no dependency resolver: the list above is deliberately ordered.
	vim.pack.add(M.specs, { load = true })
end

return M
