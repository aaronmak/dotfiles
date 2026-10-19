local M = {}

M.parsers = {
	"bash",
	"c",
	"diff",
	"html",
	"javascript",
	"jsdoc",
	"json",
	"json5",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"ninja",
	"python",
	"query",
	"regex",
	"rst",
	"terraform",
	"hcl",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
}

function M.setup()
	local ts = require("nvim-treesitter")
	ts.setup({ install_dir = vim.fn.stdpath("data") .. "/site" })
	-- Installation and updates are explicit: opening a buffer never downloads parsers.
	vim.api.nvim_create_user_command("ParsersInstall", function()
		ts.install(M.parsers)
	end, {
		desc = "Install configured Treesitter parsers",
	})
	vim.api.nvim_create_user_command("ParsersUpdate", function()
		ts.update(M.parsers)
	end, {
		desc = "Update configured Treesitter parsers",
	})

	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("native_treesitter", { clear = true }),
		callback = function(event)
			local buf = event.buf
			if vim.bo[buf].buftype ~= "" then
				return
			end
			local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
			if not lang or not pcall(vim.treesitter.start, buf, lang) then
				return
			end
			vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			for _, win in ipairs(vim.fn.win_findbuf(buf)) do
				vim.wo[win].foldmethod = "expr"
				vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
			end
		end,
	})
	require("nvim-treesitter-textobjects").setup({ move = { set_jumps = true } })
	local moves = {
		goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
		goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
		goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
		goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
	}
	for method, mappings in pairs(moves) do
		for lhs, capture in pairs(mappings) do
			vim.keymap.set({ "n", "x", "o" }, lhs, function()
				local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
				if
					lang
					and pcall(vim.treesitter.get_parser, 0, lang)
					and vim.treesitter.query.get(lang, "textobjects")
				then
					require("nvim-treesitter-textobjects.move")[method](capture, "textobjects")
				end
			end, { desc = method:gsub("_", " ") .. " " .. capture })
		end
	end
end

return M
