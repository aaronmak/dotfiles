local function map(mode, lhs, rhs, desc, opts)
	vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { silent = true, desc = desc }, opts or {}))
end
local buffers = require("config.buffers")
local files = require("config.files")

-- Keep these unconditional, including counts, as in the local configuration.
map({ "n", "x" }, "j", "gj", "Down (Display Line)")
map({ "n", "x" }, "k", "gk", "Up (Display Line)")
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", "Down", { expr = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", "Up", { expr = true })
map({ "n", "x", "o" }, "<C-n><C-h>", "<cmd>nohlsearch<cr>", "Clear Search Highlight")
map({ "n", "i", "s" }, "<Esc>", "<cmd>nohlsearch<cr><Esc>", "Escape and Clear Search")
map({ "n", "i", "x", "s" }, "<C-s>", "<cmd>write<cr><Esc>", "Save File")
map("x", "<C-c>", '"+y', "Copy to Clipboard")
map("n", "<leader>co", "<cmd>%yank +<cr>", "Copy Whole File to Clipboard")
map("n", "<leader>fy", function()
	vim.fn.setreg("+", vim.fn.expand("%"))
end, "Copy Relative Path")
map("n", "<leader>dcf", files.delete, "Delete Current File")
map("n", "<leader>rf", files.rename, "Rename Current File")

map("n", "<Tab>", buffers.next, "Next Buffer")
map("n", "<S-Tab>", buffers.previous, "Previous Buffer")
for _, key in ipairs({ "<leader>bq", "<leader>bd" }) do
	map("n", key, function()
		buffers.close()
	end, "Close Buffer")
end
map("n", "<leader>bqa", buffers.close_all, "Close All Buffers")
map("n", "<leader>bqq", buffers.close_others, "Close Other Buffers")
map("n", "<leader>bo", buffers.close_others, "Close Other Buffers")
map("n", "<leader>bi", buffers.close_invisible, "Close Invisible Buffers")
map("n", "<leader>bD", "<cmd>bdelete<cr>", "Delete Buffer and Window")
map("n", "<leader>bb", "<cmd>buffer #<cr>", "Switch to Other Buffer")
map("n", "<leader>`", "<cmd>buffer #<cr>", "Switch to Other Buffer")

for _, direction in ipairs({ "h", "j", "k", "l" }) do
	map("n", "<leader><C-" .. direction .. ">", function()
		local win = vim.api.nvim_get_current_win()
		vim.cmd("wincmd " .. direction)
		if vim.api.nvim_get_current_win() == win then
			local split = ({
				h = "leftabove vsplit",
				l = "rightbelow vsplit",
				j = "belowright split",
				k = "aboveleft split",
			})[direction]
			vim.cmd(split)
		end
	end, "Move or Split " .. direction)
end
map("n", "<C-Up>", "<cmd>resize +2<cr>", "Increase Window Height")
map("n", "<C-Down>", "<cmd>resize -2<cr>", "Decrease Window Height")
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", "Decrease Window Width")
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", "Increase Window Width")
map("n", "<leader>-", "<C-w>s", "Split Window Below")
map("n", "<leader>|", "<C-w>v", "Split Window Right")
map("n", "<leader>wd", "<C-w>c", "Close Window")

map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", "Move Down")
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", "Move Up")
map("i", "<A-j>", "<Esc><cmd>move .+1<cr>==gi", "Move Down")
map("i", "<A-k>", "<Esc><cmd>move .-2<cr>==gi", "Move Up")
map("x", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", "Move Down")
map("x", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", "Move Up")
map("x", "<", "<gv", "Indent Left")
map("x", ">", ">gv", "Indent Right")
for _, key in ipairs({ ",", ".", ";" }) do
	map("i", key, key .. "<C-g>u", "Undo Breakpoint")
end
for _, mode in ipairs({ "n", "x", "o" }) do
	map(mode, "n", "'Nn'[v:searchforward]" .. (mode == "n" and ".'zv'" or ""), "Next Search Result", { expr = true })
	map(
		mode,
		"N",
		"'nN'[v:searchforward]" .. (mode == "n" and ".'zv'" or ""),
		"Previous Search Result",
		{ expr = true }
	)
end
map("n", "<leader>K", "<cmd>normal! K<cr>", "Keyword Help")
map("n", "gco", "o<Esc>Vcx<Esc><cmd>normal gcc<cr>fxa<BS>", "Add Comment Below")
map("n", "gcO", "O<Esc>Vcx<Esc><cmd>normal gcc<cr>fxa<BS>", "Add Comment Above")
map("n", "<leader>fn", "<cmd>enew<cr>", "New File")
map("n", "<leader>qq", "<cmd>qa<cr>", "Quit All")
map("n", "<leader>ur", "<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-l><cr>", "Redraw / Clear Search / Diff Update")
map("n", "<leader>ui", vim.show_pos, "Inspect Position")
map("n", "<leader>uI", function()
	vim.treesitter.inspect_tree()
	vim.api.nvim_input("I")
end, "Inspect Tree")

for key, command in pairs({
	l = "tablast",
	o = "tabonly",
	f = "tabfirst",
	["<Tab>"] = "tabnew",
	["]"] = "tabnext",
	d = "tabclose",
	["["] = "tabprevious",
}) do
	map("n", "<leader><Tab>" .. key, "<cmd>" .. command .. "<cr>", command)
end
map("n", "<leader>xl", function()
	local command = vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and "lclose" or "lopen"
	local ok, err = pcall(vim.cmd, command)
	if not ok then
		vim.notify(err, vim.log.levels.WARN)
	end
end, "Location List")
map("n", "<leader>xq", function()
	local command = vim.fn.getqflist({ winid = 0 }).winid ~= 0 and "cclose" or "copen"
	local ok, err = pcall(vim.cmd, command)
	if not ok then
		vim.notify(err, vim.log.levels.WARN)
	end
end, "Quickfix List")
map("n", "[q", "<cmd>cprev<cr>", "Previous Quickfix")
map("n", "]q", "<cmd>cnext<cr>", "Next Quickfix")

for key, option in pairs({ us = "spell", uw = "wrap", uL = "relativenumber" }) do
	map("n", "<leader>" .. key, function()
		vim.wo[option] = not vim.wo[option]
	end, "Toggle " .. option)
end
map("n", "<leader>ul", function()
	local enable = not (vim.wo.number or vim.wo.relativenumber)
	vim.wo.number = enable
	vim.wo.relativenumber = enable
end, "Toggle Line Numbers")
local conceal = vim.o.conceallevel > 0 and vim.o.conceallevel or 2
map("n", "<leader>uc", function()
	vim.wo.conceallevel = vim.wo.conceallevel == 0 and conceal or 0
end, "Toggle Conceal")
local tabline = vim.o.showtabline > 0 and vim.o.showtabline or 2
map("n", "<leader>uA", function()
	vim.o.showtabline = vim.o.showtabline == 0 and tabline or 0
end, "Toggle Tabline")
map("n", "<leader>ub", function()
	vim.o.background = vim.o.background == "dark" and "light" or "dark"
end, "Toggle Dark Background")
map("n", "<leader>uf", function()
	require("config.format").toggle()
end, "Toggle Auto Format (Global)")
map("n", "<leader>uF", function()
	require("config.format").toggle(true)
end, "Toggle Auto Format (Buffer)")
map({ "n", "x" }, "<leader>cf", function()
	require("config.format").format()
end, "Format")
