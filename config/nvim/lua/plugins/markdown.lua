local M = {}

function M.setup()
	vim.filetype.add({ extension = { mdx = "markdown.mdx" } })
	require("render-markdown").setup({
		file_types = { "markdown", "markdown.mdx", "norg", "rmd", "org", "codecompanion" },
		code = { sign = false, width = "block", right_pad = 1 },
		heading = { sign = false, icons = {} },
		checkbox = { enabled = false },
	})
	vim.keymap.set("n", "<leader>um", function()
		require("render-markdown").toggle()
	end, { desc = "Toggle Render Markdown" })
	vim.g.mkdp_filetypes = { "markdown", "markdown.mdx" }
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "markdown", "markdown.mdx" },
		group = vim.api.nvim_create_augroup("native_markdown", { clear = true }),
		callback = function(event)
			vim.keymap.set(
				"n",
				"<leader>cp",
				"<cmd>MarkdownPreviewToggle<cr>",
				{ buffer = event.buf, desc = "Markdown Preview" }
			)
		end,
	})
end

return M
