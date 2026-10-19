local M = {}

local servers = {
	lua_ls = "lua-language-server",
	bashls = "bash-language-server",
	jsonls = "vscode-json-language-server",
	yamlls = "yaml-language-server",
	marksman = "marksman",
	pyright = "pyright-langserver",
	ruff = "ruff",
	terraformls = "terraform-ls",
	taplo = "taplo",
}
local tools = {
	"lua-language-server",
	"bash-language-server",
	"json-lsp",
	"yaml-language-server",
	"marksman",
	"pyright",
	"ruff",
	"terraform-ls",
	"taplo",
	"stylua",
	"shfmt",
	"shellcheck",
	"prettier",
	"markdownlint-cli2",
	"markdown-toc",
	"tflint",
}

local function enable_installed()
	for server, executable in pairs(servers) do
		if vim.fn.executable(executable) == 1 then
			vim.lsp.enable(server)
		end
	end
end

local function setup_tools()
	-- Disable even registry refreshes at startup; downloads require an explicit command.
	require("mason").setup({ registry_cache = { refresh = false } })
	require("mason-lspconfig").setup({ ensure_installed = {}, automatic_enable = false })
	local registry = require("mason-registry")
	registry:on("package:install:success", vim.schedule_wrap(enable_installed))
	vim.api.nvim_create_user_command("ToolsInstall", function(args)
		local requested = #args.fargs > 0 and args.fargs or tools
		for _, name in ipairs(requested) do
			if not vim.tbl_contains(tools, name) then
				vim.notify("Unknown tool: " .. name, vim.log.levels.ERROR)
				return
			end
		end
		registry.update(vim.schedule_wrap(function(ok)
			if not ok then
				vim.notify("Mason registry update failed; see :MasonLog", vim.log.levels.ERROR)
				return
			end
			for _, name in ipairs(requested) do
				local found, package = pcall(registry.get_package, name)
				if not found then
					vim.notify("Mason package unavailable: " .. name, vim.log.levels.WARN)
				elseif not package:is_installed() and not package:is_installing() then
					package:install()
				end
			end
			vim.notify("Tool installation requested; see :Mason for progress")
		end))
	end, {
		nargs = "*",
		desc = "Install selected language servers and tools (explicit network access)",
		complete = function(prefix)
			return vim.tbl_filter(function(name)
				return vim.startswith(name, prefix)
			end, tools)
		end,
	})
end

local function setup_lint()
	local lint = require("lint")
	local terraform_validate = require("lint.linters.terraform_validate")
	lint.linters.terraform_validate = function()
		local linter = terraform_validate()
		-- The process runs at the project root, not necessarily the editor's cwd.
		linter.args[1] = "-chdir=" .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
		return linter
	end
	local pending = {}
	lint.linters_by_ft = {
		sh = { "shellcheck" },
		bash = { "shellcheck" },
		fish = { "fish" },
		terraform = { "terraform_validate" },
		tf = { "terraform_validate" },
		markdown = { "markdownlint-cli2" },
		["markdown.mdx"] = { "markdownlint-cli2" },
	}
	vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave", "FileType" }, {
		group = vim.api.nvim_create_augroup("native_lint", { clear = true }),
		callback = function(event)
			local buf, token = event.buf, {}
			pending[buf] = token
			vim.defer_fn(function()
				if pending[buf] ~= token then
					return
				end
				pending[buf] = nil
				if
					not vim.api.nvim_buf_is_valid(buf)
					or not vim.api.nvim_buf_is_loaded(buf)
					or vim.bo[buf].buftype ~= ""
					or not vim.bo[buf].modifiable
				then
					return
				end
				vim.api.nvim_buf_call(buf, function()
					lint.try_lint(nil, {
						cwd = require("config.root").get(buf),
						filter = function(linter)
							local cmd = type(linter.cmd) == "function" and linter.cmd() or linter.cmd
							return type(cmd) == "string" and vim.fn.executable(cmd) == 1
						end,
					})
				end)
			end, 100)
		end,
	})
end

function M.setup()
	vim.diagnostic.config({
		underline = true,
		update_in_insert = false,
		severity_sort = true,
		virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = " ",
				[vim.diagnostic.severity.WARN] = " ",
				[vim.diagnostic.severity.INFO] = " ",
				[vim.diagnostic.severity.HINT] = " ",
			},
		},
	})
	for key, severity in pairs({ d = false, e = vim.diagnostic.severity.ERROR, w = vim.diagnostic.severity.WARN }) do
		for lhs, count in pairs({ ["]" .. key] = 1, ["[" .. key] = -1 }) do
			vim.keymap.set("n", lhs, function()
				vim.diagnostic.jump({ count = count, severity = severity or nil, float = true })
			end, { desc = (count == 1 and "Next" or "Previous") .. " " .. key .. " Diagnostic" })
		end
	end
	vim.keymap.set("n", "<leader>ud", function()
		vim.diagnostic.enable(not vim.diagnostic.is_enabled())
	end, { desc = "Toggle Diagnostics" })
	vim.keymap.set("n", "<leader>uh", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
	end, { desc = "Toggle Inlay Hints" })
	vim.filetype.add({
		filename = {
			aliases = "zsh",
			exports = "zsh",
			functions = "zsh",
			extras = "zsh",
			zshrc = "zsh",
			[".zshrc"] = "zsh",
			[".zshenv"] = "zsh",
			[".zprofile"] = "zsh",
			bashrc = "sh",
			[".bashrc"] = "sh",
			bash_profile = "sh",
			[".bash_profile"] = "sh",
		},
		extension = { tf = "terraform", tfvars = "terraform-vars", hcl = "hcl", tfstate = "json" },
	})
	setup_tools()
	vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
	vim.lsp.config("lua_ls", {
		settings = {
			Lua = {
				workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
				diagnostics = { globals = { "vim" } },
				codeLens = { enable = true },
				completion = { callSnippet = "Replace" },
				doc = { privateName = { "^_" } },
				hint = {
					enable = true,
					setType = false,
					paramType = true,
					paramName = "Disable",
					semicolon = "Disable",
					arrayIndex = "Disable",
				},
			},
		},
	})
	vim.lsp.config("jsonls", {
		before_init = function(_, config)
			config.settings.json.schemas = config.settings.json.schemas or {}
			vim.list_extend(config.settings.json.schemas, require("schemastore").json.schemas())
		end,
		settings = { json = { format = { enable = true }, validate = { enable = true } } },
	})
	vim.lsp.config("yamlls", {
		capabilities = { textDocument = { foldingRange = { dynamicRegistration = false, lineFoldingOnly = true } } },
		before_init = function(_, config)
			config.settings.yaml.schemas =
				vim.tbl_deep_extend("force", config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
		end,
		settings = {
			redhat = { telemetry = { enabled = false } },
			yaml = {
				keyOrdering = false,
				format = { enable = true },
				validate = true,
				schemaStore = { enable = false, url = "" },
			},
		},
	})
	vim.lsp.config("ruff", {
		cmd_env = { RUFF_TRACE = "messages" },
		init_options = { settings = { logLevel = "error" } },
	})
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("native_lsp", { clear = true }),
		callback = function(event)
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client and client.name == "ruff" then
				client.server_capabilities.hoverProvider = false
			end
			if
				client
				and client:supports_method("textDocument/inlayHint", event.buf)
				and vim.bo[event.buf].buftype == ""
			then
				vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
			end
			vim.bo[event.buf].formatexpr = "v:lua.vim.lsp.formatexpr()"
			local function map(lhs, rhs, desc, mode)
				vim.keymap.set(mode or "n", lhs, rhs, { buffer = event.buf, desc = desc })
			end
			for lhs, picker in pairs({
				gd = "lsp_definitions",
				gr = "lsp_references",
				gI = "lsp_implementations",
				gy = "lsp_typedefs",
			}) do
				map(lhs, function()
					require("fzf-lua")[picker]()
				end, (picker:gsub("_", " ")))
			end
			map("gD", vim.lsp.buf.declaration, "Goto Declaration")
			map("K", vim.lsp.buf.hover, "Hover")
			map("gK", vim.lsp.buf.signature_help, "Signature Help")
			map("<C-k>", vim.lsp.buf.signature_help, "Signature Help", "i")
			map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
			map("<leader>cr", vim.lsp.buf.rename, "Rename Symbol")
			map("<leader>cl", "<cmd>checkhealth vim.lsp<cr>", "LSP Info")
			map("<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")
		end,
	})
	enable_installed()
	setup_lint()
end

return M
