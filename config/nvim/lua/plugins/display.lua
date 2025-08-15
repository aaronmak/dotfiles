return {
	"TaDaa/vimade",
	{
		"lewis6991/gitsigns.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "kyazdani42/nvim-web-devicons",
		opts = {
			options = {
				numbers = function(opts)
					return string.format("%s.", opts.id)
				end,
				name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
					return vim.fn.pathshorten(vim.fn.fnamemodify(buf.path, ":~:."))
				end,
				show_buffer_close_icons = false,
				show_close_icon = false,
				max_name_length = 30,
				separator_style = "thick",
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "kyazdani42/nvim-web-devicons", lazy = true },
		opts = {
			options = {
				theme = "tokyonight",
			},
		},
	},
	"lukas-reineke/indent-blankline.nvim",
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			on_highlights = function(hl)
				hl.LineNr = {
					fg = "#ff4774",
				}
				hl.LineNrAbove = {
					fg = "#a9b1d6",
				}
				hl.LineNrBelow = {
					fg = "#a9b1d6",
				}
			end,
		},
	},
	{
		"folke/snacks.nvim",
		opts = {
			scroll = {
				animate = {
					duration = { step = 15, total = 150 },
					easing = "quad",
				},
				-- faster animation when repeating scroll after delay
				animate_repeat = {
					delay = 30,
					duration = { step = 5, total = 30 },
					easing = "quad",
				},
			},
			indent = {
				-- your indent configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
				animate = {
					enabled = vim.fn.has("nvim-0.10") == 1,
					style = "out",
					easing = "linear",
					duration = {
						step = 5, -- ms per step
						total = 200, -- maximum duration
					},
				},
			},
		},
	},
}
