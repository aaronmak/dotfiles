local M = {}
local uv = vim.uv

local function warn(message)
	vim.notify(message, vim.log.levels.WARN)
end

local function current_file()
	local buf = vim.api.nvim_get_current_buf()
	local name = vim.api.nvim_buf_get_name(buf)
	if vim.bo[buf].buftype ~= "" or name == "" or name:match("^%w[%w+.-]*://") then
		warn("This buffer is not a local file")
		return
	end
	if vim.bo[buf].modified then
		warn("Save changes before renaming or deleting this file")
		return
	end
	local stat, err = uv.fs_lstat(name)
	if not stat or (stat.type ~= "file" and stat.type ~= "link") then
		warn("Not an existing file: " .. name .. (err and ("\n" .. err) or ""))
		return
	end
	return buf, name
end

local function unchanged(buf, name)
	return vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_name(buf) == name and not vim.bo[buf].modified
end

function M.delete()
	local buf, name = current_file()
	if not buf then
		return false
	end
	if vim.fn.confirm("Permanently delete this file?\n" .. name, "&Delete\n&Cancel", 2) ~= 1 then
		return false
	end
	if not unchanged(buf, name) then
		warn("Buffer changed; deletion cancelled")
		return false
	end
	local ok, err = uv.fs_unlink(name)
	if not ok then
		warn("Could not delete file: " .. tostring(err))
		return false
	end
	if not require("config.buffers").close(buf) then
		warn("File deleted, but the buffer could not be closed")
	end
	return true
end

function M.rename()
	local buf, old = current_file()
	if not buf then
		return false
	end
	local ok, input = pcall(vim.fn.input, {
		prompt = "New file name: ",
		default = vim.fn.fnamemodify(old, ":."),
		completion = "file",
	})
	if not ok or not input or input == "" then
		return false
	end
	if input:find("[%z\r\n]") or input:match("^%w[%w+.-]*://") then
		warn("Enter a local file path")
		return false
	end
	local new = vim.fs.normalize(vim.fn.fnamemodify(input, ":p"), { expand_env = false })
	if new == old then
		return false
	end
	if uv.fs_lstat(new) then
		warn("Destination already exists: " .. new)
		return false
	end
	local parent = uv.fs_stat(vim.fs.dirname(new))
	if not parent or parent.type ~= "directory" then
		warn("Destination directory does not exist")
		return false
	end
	for _, other in ipairs(vim.api.nvim_list_bufs()) do
		if other ~= buf and vim.api.nvim_buf_get_name(other) == new then
			warn("Destination already has an open buffer")
			return false
		end
	end
	if vim.fn.confirm("Rename file?\n" .. old .. "\n→ " .. new, "&Rename\n&Cancel", 2) ~= 1 then
		return false
	end
	if not unchanged(buf, old) or uv.fs_lstat(new) then
		warn("File or buffer changed; rename cancelled")
		return false
	end
	local renamed, err = uv.fs_rename(old, new)
	if not renamed then
		warn("Could not rename file: " .. tostring(err))
		return false
	end
	local views = {}
	for _, win in ipairs(vim.fn.win_findbuf(buf)) do
		views[win] = vim.api.nvim_win_call(win, vim.fn.winsaveview)
	end
	local named, name_err = pcall(function()
		vim.api.nvim_buf_set_name(buf, new)
		-- Reload the saved file to reset Neovim's renamed-buffer write protection.
		-- No bang: an autocmd introducing edits must never have them discarded.
		vim.api.nvim_buf_call(buf, function()
			vim.cmd("silent keepalt edit")
		end)
	end)
	for win, view in pairs(views) do
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_call(win, function()
				vim.fn.winrestview(view)
			end)
		end
	end
	if not named then
		local restored, restore_err
		if not uv.fs_lstat(old) then
			restored, restore_err = uv.fs_rename(new, old)
		end
		if restored then
			pcall(vim.api.nvim_buf_set_name, buf, old)
		end
		warn(
			"Could not update buffer name: "
				.. tostring(name_err)
				.. (
					restored and "\nFile rename rolled back"
					or ("\nFile remains at " .. new .. ": " .. tostring(restore_err))
				)
		)
		return false
	end
	vim.notify("Renamed to " .. new)
	return true
end

return M
