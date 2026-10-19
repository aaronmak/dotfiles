local group = vim.api.nvim_create_augroup("config_general", { clear = true })
local function autocmd(events, opts)
	opts.group = group
	vim.api.nvim_create_autocmd(events, opts)
end

autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	callback = function()
		if vim.bo.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

autocmd("TextYankPost", {
	callback = function()
		if vim.fn.has("nvim-0.13") == 1 then
			vim.hl.hl_op()
		else
			(vim.hl or vim.highlight).on_yank()
		end
	end,
})

autocmd("VimResized", {
	callback = function()
		local tab = vim.api.nvim_get_current_tabpage()
		vim.cmd("tabdo wincmd =")
		if vim.api.nvim_tabpage_is_valid(tab) then
			vim.api.nvim_set_current_tabpage(tab)
		end
	end,
})

autocmd("BufReadPost", {
	callback = function(event)
		if vim.bo[event.buf].filetype == "gitcommit" or vim.b[event.buf].config_last_loc then
			return
		end
		vim.b[event.buf].config_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
		if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(event.buf) then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

autocmd("FileType", {
	pattern = {
		"PlenaryTestPopup",
		"checkhealth",
		"dap-float",
		"dbout",
		"gitsigns-blame",
		"grug-far",
		"help",
		"lspinfo",
		"neotest-output",
		"neotest-output-panel",
		"neotest-summary",
		"notify",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "Close Window" })
	end,
})

autocmd("FileType", {
	pattern = "man",
	callback = function(event)
		vim.bo[event.buf].buflisted = false
	end,
})

autocmd("FileType", {
	pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

autocmd("FileType", {
	pattern = { "json", "jsonc", "json5" },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})

autocmd({ "BufReadPost", "BufNewFile", "FileType" }, {
	callback = function(event)
		vim.bo[event.buf].formatoptions = vim.bo[event.buf].formatoptions:gsub("[cro]", "")
	end,
})

autocmd("BufWritePre", {
	callback = function(event)
		local buf = event.buf
		local name = vim.api.nvim_buf_get_name(buf)
		if vim.bo[buf].buftype ~= "" or name == "" or name:match("^%w[%w+.-]*://") then
			return
		end
		local file = vim.uv.fs_realpath(name) or name
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")

		-- Preserve Markdown's two-space hard breaks. Buffer APIs leave search and views alone.
		if vim.bo[buf].filetype == "markdown" or not vim.bo[buf].modifiable then
			return
		end
		local views = {}
		for _, win in ipairs(vim.fn.win_findbuf(buf)) do
			views[win] = vim.api.nvim_win_call(win, vim.fn.winsaveview)
		end
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		for i, line in ipairs(lines) do
			local clean = line:gsub("[ \t]+$", "")
			if clean ~= line then
				vim.api.nvim_buf_set_text(buf, i - 1, #clean, i - 1, #line, {})
			end
		end
		for win, view in pairs(views) do
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_call(win, function()
					vim.fn.winrestview(view)
				end)
			end
		end
	end,
})
