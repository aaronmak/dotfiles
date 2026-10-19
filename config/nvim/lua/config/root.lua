local M = {}

function M.get(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local file = vim.api.nvim_buf_get_name(bufnr)
	local roots = {}
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		local root = client.config.root_dir
		if type(root) == "string" and (file == root or vim.startswith(file, root .. "/")) then
			roots[#roots + 1] = root
		end
	end
	table.sort(roots, function(a, b)
		return #a > #b
	end)
	return roots[1] or vim.fs.root(file ~= "" and file or vim.fn.getcwd(), { ".git", "lua" }) or vim.fn.getcwd()
end

return M
