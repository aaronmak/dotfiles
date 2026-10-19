local M = {}

function M.setup()
	for key, direction in pairs({ h = "Left", j = "Down", k = "Up", l = "Right", ["\\"] = "Previous" }) do
		vim.keymap.set("n", "<C-" .. key .. ">", "<cmd>TmuxNavigate" .. direction .. "<cr>", {
			desc = "Navigate " .. direction,
			silent = true,
		})
	end
end

return M
