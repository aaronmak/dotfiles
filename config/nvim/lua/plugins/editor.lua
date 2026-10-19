local M = {}

function M.setup()
	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
	end

	local fzf = require("fzf-lua")
	local actions = require("fzf-lua.actions")
	local function toggle_root(_, ctx)
		local opts = vim.deepcopy(ctx.__call_opts)
		opts.root = opts.root == false
		opts.cwd = opts.root and require("config.root").get(ctx.__CTX.bufnr) or vim.fn.getcwd()
		fzf[ctx.__INFO.cmd](opts)
	end
	require("fzf-lua.config").set_action_helpstr(toggle_root, "toggle-root-dir")
	fzf.setup({
		"default-title",
		fzf_colors = true,
		fzf_opts = { ["--no-scrollbar"] = true },
		defaults = { formatter = "path.dirname_first" },
		winopts = { width = 0.8, height = 0.8, row = 0.5, col = 0.5, preview = { scrollchars = { "┃", "" } } },
		keymap = {
			fzf = {
				true, -- Keep the built-in accept, abort, and navigation bindings.
				["ctrl-q"] = "select-all+accept",
				["ctrl-u"] = "half-page-up",
				["ctrl-d"] = "half-page-down",
				["ctrl-x"] = "jump",
				["ctrl-f"] = "preview-page-down",
				["ctrl-b"] = "preview-page-up",
			},
			builtin = { true, ["<c-f>"] = "preview-page-down", ["<c-b>"] = "preview-page-up" },
		},
		actions = { files = { true, ["ctrl-r"] = toggle_root, ["alt-c"] = toggle_root } },
		files = {
			cwd_prompt = false,
			actions = { ["alt-i"] = actions.toggle_ignore, ["alt-h"] = actions.toggle_hidden },
		},
		grep = { actions = { ["alt-i"] = actions.toggle_ignore, ["alt-h"] = actions.toggle_hidden } },
	})
	fzf.register_ui_select(function(opts, items)
		return {
			prompt = " ",
			winopts = {
				title = " " .. vim.trim((opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
				title_pos = "center",
				width = 0.5,
				height = math.min(0.8, (#items + 4) / vim.o.lines),
			},
		}
	end)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "fzf",
		group = vim.api.nvim_create_augroup("FzfTerminalKeys", { clear = true }),
		callback = function(event)
			for _, key in ipairs({ "<c-j>", "<c-k>" }) do
				vim.keymap.set("t", key, key, { buffer = event.buf, nowait = true })
			end
		end,
	})

	-- Resolve the root at invocation, not when the configuration is loaded.
	local function pick(command, root, opts)
		return function()
			local options = vim.tbl_extend("force", {}, opts or {})
			if root ~= nil then
				options.root = root
				options.cwd = root and require("config.root").get() or vim.fn.getcwd()
			end
			fzf[command](options)
		end
	end
	map("n", "<leader>,", pick("buffers", nil, { sort_mru = true, sort_lastused = true }), "Switch Buffer")
	map("n", "<leader>/", pick("live_grep", true), "Grep (Root Dir)")
	map("n", "<leader>:", pick("command_history"), "Command History")
	map("n", "<leader><space>", pick("files", true), "Find Files (Root Dir)")
	map("n", "<leader>fb", pick("buffers", nil, { sort_mru = true, sort_lastused = true }), "Buffers")
	map("n", "<leader>fB", pick("buffers"), "Buffers (all)")
	map("n", "<leader>fc", pick("files", nil, { cwd = vim.fn.stdpath("config") }), "Find Config File")
	map("n", "<leader>ff", pick("files", true), "Find Files (Root Dir)")
	map("n", "<leader>fF", pick("files", false), "Find Files (cwd)")
	map("n", "<leader>fg", pick("git_files", true), "Find Files (git-files)")
	map("n", "<leader>fr", pick("oldfiles"), "Recent")
	map("n", "<leader>fR", pick("oldfiles", false, { cwd_only = true }), "Recent (cwd)")
	for lhs, picker in pairs({
		gc = "git_commits",
		gd = "git_diff",
		gl = "git_commits",
		gs = "git_status",
		gS = "git_stash",
	}) do
		map("n", "<leader>" .. lhs, pick(picker, true), picker:gsub("_", " "))
	end
	for lhs, picker in pairs({
		['s"'] = "registers",
		["s/"] = "search_history",
		sa = "autocmds",
		sb = "lines",
		sc = "command_history",
		sC = "commands",
		sd = "diagnostics_workspace",
		sD = "diagnostics_document",
		sh = "help_tags",
		sH = "highlights",
		sj = "jumps",
		sk = "keymaps",
		sl = "loclist",
		sM = "man_pages",
		sm = "marks",
		sR = "resume",
		sq = "quickfix",
		uC = "colorschemes",
		ss = "lsp_document_symbols",
		sS = "lsp_live_workspace_symbols",
	}) do
		map("n", "<leader>" .. lhs, pick(picker), picker:gsub("_", " "))
	end
	map("n", "<leader>sg", pick("live_grep", true), "Grep (Root Dir)")
	map("n", "<leader>sG", pick("live_grep", false), "Grep (cwd)")
	map("n", "<leader>sw", pick("grep_cword", true), "Word (Root Dir)")
	map("n", "<leader>sW", pick("grep_cword", false), "Word (cwd)")
	map("x", "<leader>sw", pick("grep_visual", true), "Selection (Root Dir)")
	map("x", "<leader>sW", pick("grep_visual", false), "Selection (cwd)")

	require("gitsigns").setup({
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},
		signs_staged = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
		},
		on_attach = function(buffer)
			local gs = require("gitsigns")
			local function hmap(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc, silent = true })
			end
			hmap("n", "]h", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gs.nav_hunk("next")
				end
			end, "Next Hunk")
			hmap("n", "[h", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gs.nav_hunk("prev")
				end
			end, "Prev Hunk")
			hmap("n", "]H", function()
				gs.nav_hunk("last")
			end, "Last Hunk")
			hmap("n", "[H", function()
				gs.nav_hunk("first")
			end, "First Hunk")
			hmap({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<cr>", "Stage Hunk")
			hmap({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<cr>", "Reset Hunk")
			hmap("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
			hmap("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
			hmap("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
			hmap("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
			hmap("n", "<leader>ghb", function()
				gs.blame_line({ full = true })
			end, "Blame Line")
			hmap("n", "<leader>ghB", gs.blame, "Blame Buffer")
			hmap("n", "<leader>ghd", gs.diffthis, "Diff This")
			hmap("n", "<leader>ghD", function()
				gs.diffthis("~")
			end, "Diff This ~")
			hmap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<cr>", "GitSigns Select Hunk")
		end,
	})
	map("n", "<leader>uG", function()
		require("gitsigns").toggle_signs()
	end, "Toggle Git Signs")

	local illuminate = require("illuminate")
	illuminate.configure({ delay = 200, large_file_cutoff = 2000, large_file_overrides = { providers = { "lsp" } } })
	map("n", "<leader>ux", illuminate.toggle, "Toggle Illuminate")
	local function reference_maps(buffer)
		vim.keymap.set("n", "]]", function()
			illuminate.goto_next_reference(false)
		end, { buffer = buffer, desc = "Next Reference" })
		vim.keymap.set("n", "[[", function()
			illuminate.goto_prev_reference(false)
		end, { buffer = buffer, desc = "Prev Reference" })
	end
	reference_maps(nil)
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("IlluminateKeys", { clear = true }),
		callback = function(event)
			reference_maps(event.buf)
		end,
	})

	local todo = require("todo-comments")
	todo.setup({})
	map("n", "]t", todo.jump_next, "Next Todo Comment")
	map("n", "[t", todo.jump_prev, "Previous Todo Comment")
	map("n", "<leader>st", function()
		require("todo-comments.fzf").todo({ cwd = require("config.root").get() })
	end, "Todo")
	map("n", "<leader>sT", function()
		require("todo-comments.fzf").todo({ cwd = require("config.root").get(), keywords = { "TODO", "FIX", "FIXME" } })
	end, "Todo/Fix/Fixme")
	map("n", "<leader>xt", function()
		require("todo-comments.search").setqflist({ cwd = require("config.root").get() })
	end, "Todo (Quickfix)")
	map("n", "<leader>xT", function()
		require("todo-comments.search").setqflist({
			cwd = require("config.root").get(),
			keywords = "TODO,FIX,FIXME",
		})
	end, "Todo/Fix/Fixme (Quickfix)")

	local grug = require("grug-far")
	grug.setup({ headerMaxWidth = 80 })
	map({ "n", "x" }, "<leader>sr", function()
		local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
		grug.open({ transient = true, prefills = { filesFilter = ext and ext ~= "" and "*." .. ext or nil } })
	end, "Search and Replace")

	local persistence = require("persistence")
	persistence.setup({})
	map("n", "<leader>qs", function()
		persistence.load()
	end, "Restore Session")
	map("n", "<leader>qS", function()
		persistence.select()
	end, "Select Session")
	map("n", "<leader>ql", function()
		persistence.load({ last = true })
	end, "Restore Last Session")
	map("n", "<leader>qd", function()
		persistence.stop()
	end, "Don't Save Current Session")
end

return M
