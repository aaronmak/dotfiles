local M = {}

local function listed()
	return vim.tbl_filter(function(buf)
		return vim.bo[buf].buflisted
	end, vim.api.nvim_list_bufs())
end

local function report(err)
	vim.notify(tostring(err), vim.log.levels.WARN)
end

local function saved(buf)
	if not vim.bo[buf].modified then
		return true
	end
	local name = vim.api.nvim_buf_get_name(buf)
	if vim.fn.confirm("Save changes to " .. (name ~= "" and name or "[No Name]") .. "?", "&Save\n&Cancel", 2) ~= 1 then
		return false
	end
	local ok, err = pcall(vim.api.nvim_buf_call, buf, function()
		vim.cmd("write")
	end)
	if not ok then
		report(err)
	end
	return ok and not vim.bo[buf].modified
end

local function step(direction)
	local bufs = listed()
	local current = vim.api.nvim_get_current_buf()
	for i, buf in ipairs(bufs) do
		if buf == current then
			vim.api.nvim_set_current_buf(bufs[(i - 1 + direction) % #bufs + 1])
			return
		end
	end
	if #bufs > 0 then
		vim.api.nvim_set_current_buf(direction == 1 and bufs[1] or bufs[#bufs])
	end
end

function M.next()
	step(1)
end

function M.previous()
	step(-1)
end

-- Change what each window displays before deleting, so splits and tabs survive.
function M.close(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	if not vim.api.nvim_buf_is_valid(buf) then
		return true
	end
	if not saved(buf) then
		return false
	end
	local replacement
	local alternate = vim.fn.bufnr("#")
	for _, candidate in ipairs(listed()) do
		if candidate ~= buf and (not replacement or candidate == alternate) then
			replacement = candidate
		end
	end
	local wins = vim.fn.win_findbuf(buf)
	if #wins > 0 and not replacement then
		replacement = vim.api.nvim_create_buf(true, false)
	end
	for _, win in ipairs(wins) do
		local ok, err = pcall(vim.api.nvim_win_set_buf, win, replacement)
		if not ok then
			for _, previous in ipairs(wins) do
				if vim.api.nvim_win_is_valid(previous) and vim.api.nvim_buf_is_valid(buf) then
					pcall(vim.api.nvim_win_set_buf, previous, buf)
				end
			end
			report(err)
			return false
		end
	end
	if not vim.api.nvim_buf_is_valid(buf) then
		return true -- A bufhidden=wipe buffer disappears when its final window changes.
	end
	local ok, err = pcall(vim.api.nvim_buf_delete, buf, { force = false })
	if not ok then
		for _, win in ipairs(wins) do
			if vim.api.nvim_win_is_valid(win) and vim.api.nvim_buf_is_valid(buf) then
				pcall(vim.api.nvim_win_set_buf, win, buf)
			end
		end
		report(err)
	end
	return ok
end

local function close_matching(predicate)
	local targets = vim.tbl_filter(predicate, listed())
	-- A cancelled save leaves the whole layout intact.
	for _, buf in ipairs(targets) do
		if not saved(buf) then
			return false
		end
	end
	for _, buf in ipairs(targets) do
		if not M.close(buf) then
			return false
		end
	end
	return true
end

function M.close_all()
	return close_matching(function()
		return true
	end)
end

function M.close_others()
	local current = vim.api.nvim_get_current_buf()
	return close_matching(function(buf)
		return buf ~= current
	end)
end

function M.close_invisible()
	return close_matching(function(buf)
		return #vim.fn.win_findbuf(buf) == 0
	end)
end

return M
