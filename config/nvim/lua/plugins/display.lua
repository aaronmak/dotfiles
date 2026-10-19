local M = {}

function M.setup()
	-- Install the devicons shim before any UI plugin asks for icons.
	local icons = require("mini.icons")
	icons.setup({
		file = {
			[".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
			["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
		},
		filetype = { dotenv = { glyph = "", hl = "MiniIconsYellow" } },
	})
	icons.mock_nvim_web_devicons()

	require("tokyonight").setup({
		on_highlights = function(hl)
			hl.LineNr = { fg = "#ff4774" }
			hl.LineNrAbove = { fg = "#a9b1d6" }
			hl.LineNrBelow = { fg = "#a9b1d6" }
		end,
	})
	vim.cmd.colorscheme("tokyonight")

	local snacks = require("snacks")
	snacks.setup({
		bigfile = { enabled = true },
		quickfile = { enabled = true },
		notifier = { enabled = true },
		indent = {
			enabled = true,
			animate = {
				enabled = vim.fn.has("nvim-0.10") == 1,
				style = "out",
				easing = "linear",
				duration = { step = 5, total = 200 },
			},
		},
		scroll = {
			enabled = true,
			animate = { duration = { step = 15, total = 150 }, easing = "linear" },
			animate_repeat = { delay = 20, duration = { step = 5, total = 50 }, easing = "linear" },
		},
		dashboard = {
			enabled = true,
			-- Explicit sections avoid the plugin-manager-dependent startup section.
			sections = { { section = "header" }, { section = "keys", gap = 1, padding = 1 } },
			preset = {
				header = [[
      ████████╗██╗  ██╗██╗███╗   ██╗██╗  ██╗    ████████╗███████╗███████╗████████╗    ████████╗██╗   ██╗██████╗ ███████╗ .
      ╚══██╔══╝██║  ██║██║████╗  ██║██║ ██╔╝    ╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝    ╚══██╔══╝╚██╗ ██╔╝██╔══██╗██╔════╝ .
         ██║   ███████║██║██╔██╗ ██║█████╔╝        ██║   █████╗  ███████╗   ██║          ██║    ╚████╔╝ ██████╔╝█████╗   .
         ██║   ██╔══██║██║██║╚██╗██║██╔═██╗        ██║   ██╔══╝  ╚════██║   ██║          ██║     ╚██╔╝  ██╔═══╝ ██╔══╝   .
         ██║   ██║  ██║██║██║ ╚████║██║  ██╗       ██║   ███████╗███████║   ██║          ██║      ██║   ██║     ███████  .
]],
				keys = {
					{
						icon = " ",
						key = "f",
						desc = "Find File",
						action = function()
							require("fzf-lua").files({ cwd = require("config.root").get() })
						end,
					},
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{
						icon = " ",
						key = "g",
						desc = "Find Text",
						action = function()
							require("fzf-lua").live_grep({ cwd = require("config.root").get() })
						end,
					},
					{
						icon = " ",
						key = "r",
						desc = "Recent Files",
						action = function()
							require("fzf-lua").oldfiles()
						end,
					},
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = function()
							require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
						end,
					},
					{
						icon = " ",
						key = "s",
						desc = "Restore Session",
						action = function()
							require("persistence").load()
						end,
					},
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
		},
		explorer = { enabled = false },
		terminal = { enabled = false },
		lazygit = { enabled = false },
		gitbrowse = { enabled = false },
		scratch = { enabled = false },
		words = { enabled = false },
		picker = { enabled = false },
		input = { enabled = false },
		scope = { enabled = false },
		statuscolumn = { enabled = false },
		image = { enabled = false },
	})

	local map = function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
	end
	map("n", "<leader>n", function()
		snacks.notifier.show_history()
	end, "Notification History")
	map("n", "<leader>un", function()
		snacks.notifier.hide()
	end, "Dismiss All Notifications")
	snacks.toggle.indent():map("<leader>ug")
	snacks.toggle.scroll():map("<leader>uS")
	snacks.toggle.animate():map("<leader>ua")

	require("which-key").setup({
		preset = "helix",
		spec = {
			{
				mode = { "n", "x" },
				{ "<leader><tab>", group = "tabs" },
				{ "<leader>c", group = "code" },
				{ "<leader>f", group = "file/find" },
				{ "<leader>g", group = "git" },
				{ "<leader>gh", group = "hunks" },
				{ "<leader>q", group = "quit/session" },
				{ "<leader>s", group = "search" },
				{ "<leader>sn", group = "noice" },
				{ "<leader>u", group = "ui" },
				{ "<leader>x", group = "diagnostics/quickfix" },
				{ "[", group = "prev" },
				{ "]", group = "next" },
				{ "g", group = "goto" },
				{ "gs", group = "surround" },
				{ "z", group = "fold" },
				{
					"<leader>b",
					group = "buffer",
					expand = function()
						return require("which-key.extras").expand.buf()
					end,
				},
				{
					"<leader>w",
					group = "windows",
					proxy = "<c-w>",
					expand = function()
						return require("which-key.extras").expand.win()
					end,
				},
			},
		},
	})
	map("n", "<leader>?", function()
		require("which-key").show({ global = false })
	end, "Buffer Keymaps (which-key)")
	map("n", "<c-w><space>", function()
		require("which-key").show({ keys = "<c-w>", loop = true })
	end, "Window Hydra Mode (which-key)")

	local noice = require("noice")
	noice.setup({
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
		},
		routes = {
			{
				filter = {
					event = "msg_show",
					any = {
						{ find = "%d+L, %d+B" },
						{ find = "; after #%d+" },
						{ find = "; before #%d+" },
					},
				},
				view = "mini",
			},
		},
		presets = { bottom_search = true, command_palette = true, long_message_to_split = true },
	})
	map("c", "<S-Enter>", function()
		noice.redirect(vim.fn.getcmdline())
	end, "Redirect Cmdline")
	for lhs, command in pairs({ snl = "last", snh = "history", sna = "all", snd = "dismiss", snt = "fzf" }) do
		map("n", "<leader>" .. lhs, function()
			noice.cmd(command)
		end, "Noice " .. command)
	end
	vim.keymap.set({ "i", "n", "s" }, "<c-f>", function()
		if not require("noice.lsp").scroll(4) then
			return "<c-f>"
		end
	end, { silent = true, expr = true, desc = "Scroll Forward" })
	vim.keymap.set({ "i", "n", "s" }, "<c-b>", function()
		if not require("noice.lsp").scroll(-4) then
			return "<c-b>"
		end
	end, { silent = true, expr = true, desc = "Scroll Backward" })

	local function close_buffer(buf)
		return require("config.buffers").close(buf)
	end
	require("bufferline").setup({
		options = {
			close_command = close_buffer,
			right_mouse_command = close_buffer,
			numbers = function(opts)
				return string.format("%s.", opts.id)
			end,
			name_formatter = function(buf)
				return vim.fn.pathshorten(vim.fn.fnamemodify(buf.path, ":~:."))
			end,
			show_buffer_close_icons = false,
			show_close_icon = false,
			max_name_length = 30,
			separator_style = "thick",
			diagnostics = "nvim_lsp",
			always_show_bufferline = false,
		},
	})
	for lhs, command in pairs({
		["<leader>bp"] = "TogglePin",
		["<leader>bP"] = "GroupClose ungrouped",
		["<leader>br"] = "CloseRight",
		["<leader>bl"] = "CloseLeft",
		["<leader>bj"] = "Pick",
		["<S-h>"] = "CyclePrev",
		["<S-l>"] = "CycleNext",
		["[b"] = "CyclePrev",
		["]b"] = "CycleNext",
		["[B"] = "MovePrev",
		["]B"] = "MoveNext",
	}) do
		map("n", lhs, "<cmd>BufferLine" .. command .. "<cr>", "Buffer " .. command)
	end
	vim.api.nvim_create_autocmd("SessionLoadPost", {
		group = vim.api.nvim_create_augroup("BufferlineSession", { clear = true }),
		callback = function()
			vim.schedule(function()
				pcall(_G.nvim_bufferline)
			end)
		end,
	})

	require("lualine").setup({
		options = {
			theme = "tokyonight",
			globalstatus = vim.o.laststatus == 3,
			disabled_filetypes = { statusline = { "snacks_dashboard" } },
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch" },
			lualine_c = {
				{
					function()
						return "󱉭 " .. vim.fn.fnamemodify(require("config.root").get(), ":t")
					end,
				},
				{ "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = " " } },
				{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
				{ "filename", path = 1, symbols = { modified = " ", readonly = " ", unnamed = "[No Name]" } },
			},
			lualine_x = {
				{
					function()
						return noice.api.status.command.get()
					end,
					cond = function()
						return noice.api.status.command.has()
					end,
				},
				{
					function()
						return noice.api.status.mode.get()
					end,
					cond = function()
						return noice.api.status.mode.has()
					end,
				},
				{
					function()
						local clients = vim.lsp.get_clients({ bufnr = 0 })
						return table.concat(
							vim.tbl_map(function(client)
								return client.name
							end, clients),
							", "
						)
					end,
					icon = "",
				},
				{
					"diff",
					symbols = { added = " ", modified = " ", removed = " " },
					source = function()
						local status = vim.b.gitsigns_status_dict
						if status then
							return { added = status.added, modified = status.changed, removed = status.removed }
						end
					end,
				},
			},
			lualine_y = {
				{ "progress", separator = " ", padding = { left = 1, right = 0 } },
				{ "location", padding = { left = 0, right = 1 } },
			},
			lualine_z = {
				function()
					return " " .. os.date("%R")
				end,
			},
		},
		extensions = { "fzf", "quickfix" },
	})
	require("vimade").setup({})
end

return M
