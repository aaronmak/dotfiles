local M = {}

function M.enabled(bufnr)
	local override = vim.b[bufnr or 0].autoformat
	if override ~= nil then
		return override
	end
	return vim.g.autoformat ~= false
end

function M.toggle(buffer_local)
	if buffer_local then
		vim.b.autoformat = not M.enabled(0)
		vim.notify("Buffer autoformat " .. (vim.b.autoformat and "enabled" or "disabled"))
	else
		vim.g.autoformat = vim.g.autoformat == false
		vim.notify("Global autoformat " .. (vim.g.autoformat and "enabled" or "disabled"))
	end
end

function M.format(opts)
	return require("conform").format(vim.tbl_extend("force", {
		bufnr = vim.api.nvim_get_current_buf(),
		timeout_ms = 3000,
		async = false,
		lsp_format = "fallback",
	}, opts or {}))
end

function M.setup()
	require("conform").setup({
		default_format_opts = { timeout_ms = 3000, async = false, lsp_format = "fallback" },
		formatters_by_ft = {
			lua = { "stylua" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			fish = { "fish_indent" },
			python = { "ruff_format" },
			hcl = { "packer_fmt" },
			terraform = { "terraform_fmt" },
			tf = { "terraform_fmt" },
			["terraform-vars"] = { "terraform_fmt" },
			-- TOML formatting is supplied by taplo through the LSP fallback.
			json = { "prettier" },
			jsonc = { "prettier" },
			json5 = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier", "markdownlint-cli2", "markdown-toc" },
			["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
		},
		formatters = {
			injected = { options = { ignore_errors = true } },
			["markdown-toc"] = {
				condition = function(_, ctx)
					for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
						if line:find("<!%-%- toc %-%->") then
							return true
						end
					end
					return false
				end,
			},
			["markdownlint-cli2"] = {
				condition = function(_, ctx)
					for _, diagnostic in ipairs(vim.diagnostic.get(ctx.buf)) do
						if diagnostic.source == "markdownlint" then
							return true
						end
					end
					return false
				end,
			},
		},
		format_on_save = function(bufnr)
			if not M.enabled(bufnr) or vim.bo[bufnr].buftype ~= "" then
				return
			end
			return { timeout_ms = 3000, async = false, lsp_format = "fallback" }
		end,
	})
	vim.keymap.set({ "n", "x" }, "<leader>cF", function()
		M.format({ formatters = { "injected" } })
	end, { desc = "Format Injected Languages" })
end

return M
