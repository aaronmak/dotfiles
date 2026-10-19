local M = {}

function M.setup()
	require("snippets").setup({ friendly_snippets = true })
	local cmp = require("cmp")
	cmp.setup({
		completion = { completeopt = "menu,menuone,noinsert" },
		preselect = cmp.PreselectMode.Item,
		snippet = {
			expand = function(args)
				vim.snippet.expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<C-y>"] = cmp.mapping.confirm({ select = true }),
			["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
			["<C-CR>"] = function(fallback)
				cmp.abort()
				fallback()
			end,
			["<Tab>"] = cmp.mapping(function(fallback)
				if vim.snippet.active({ direction = 1 }) then
					vim.snippet.jump(1)
				else
					fallback()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if vim.snippet.active({ direction = -1 }) then
					vim.snippet.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "path" },
			{ name = "snippets" },
		}, { { name = "buffer" } }),
	})

	local ai = require("mini.ai")
	ai.setup({
		n_lines = 500,
		custom_textobjects = {
			o = ai.gen_spec.treesitter({
				a = { "@block.outer", "@conditional.outer", "@loop.outer" },
				i = { "@block.inner", "@conditional.inner", "@loop.inner" },
			}),
			f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
			c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
			t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
			d = { "%f[%d]%d+" },
			e = {
				{ "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
				"^().*()$",
			},
			g = function()
				local last = vim.api.nvim_buf_line_count(0)
				return { from = { line = 1, col = 1 }, to = { line = last, col = math.max(#vim.fn.getline(last), 1) } }
			end,
			u = ai.gen_spec.function_call(),
			U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
		},
	})
	require("ts_context_commentstring").setup({ enable_autocmd = false })
	require("mini.comment").setup({
		options = {
			custom_commentstring = function()
				return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
			end,
		},
	})
	require("mini.surround").setup({
		mappings = {
			add = "gsa",
			delete = "gsd",
			find = "gsf",
			find_left = "gsF",
			highlight = "gsh",
			replace = "gsr",
			update_n_lines = "gsn",
		},
	})
	local hipatterns = require("mini.hipatterns")
	hipatterns.setup({
		highlighters = {
			fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
			hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
			todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
			note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
			hex_color = hipatterns.gen_highlighter.hex_color({ priority = 2000 }),
		},
	})
end

return M
