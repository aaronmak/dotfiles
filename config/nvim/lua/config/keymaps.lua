vim.g.mapleader = " "

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map("", "<C-n><C-h>", ":nohlsearch<CR>") -- Fast switch off highlights

map("", "<C-s>", "<ESC>:w<CR>") -- Fast saving
map("i", "<C-s>", "<ESC>:w<CR>")
map("n", "<C-s>", ":w<CR>")
map("v", "<C-c>", "+y") -- Copy to system clipboard

-- Switch buffers with tab
map("n", "<Tab>", ":bnext!<CR>")
map("n", "<S-Tab>", ":bprev!<CR>")

-- Close current buffer
map("n", "<leader>bq", ":bp <bar> bd! #<cr>")

-- Close all buffers
map("n", "<leader>bqa", ":%bdelete <cr>")

-- Close all buffers except current
map("n", "<leader>bqq", ":%bd|e# <cr>")

-- Move up and down by visible lines if current line is wrapped
map("n", "j", "gj")
map("n", "k", "gk")

-- Move to the split in the direction shown, or create a new split
map("n", "<leader><C-h>", ':call WinMove("h")<cr>', { silent = true })
map("n", "<leader><C-j>", ':call WinMove("j")<cr>', { silent = true })
map("n", "<leader><C-k>", ':call WinMove("k")<cr>', { silent = true })
map("n", "<leader><C-l>", ':call WinMove("l")<cr>', { silent = true })
vim.api.nvim_command([[
  function! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
      if (match(a:key,'[jk]'))
        wincmd v
      else
        wincmd s
      endif
      exec "wincmd ".a:key
    endif
  endfunction
]])

map("n", "<leader>dcf", ":!rm %<cr>") -- delete current file
map("n", "<leader>co", ":%y+<cr>") -- copy all

vim.api.nvim_command([[
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
]])

map("", "<Leader>rf", ":call RenameFile()<cr>")
