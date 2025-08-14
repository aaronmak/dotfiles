return {
   {
     "nvim-telescope/telescope.nvim",
     dependencies = { 'nvim-lua/plenary.nvim' },
     keys = {
       -- add a keymap to browse plugin files
       -- stylua: ignore
       {
         "<leader>fp",
         function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
         desc = "Find Plugin File",
       },
       {'<leader>ff', ':Telescope find_files<cr>'},
       {'<leader>fg', ':Telescope live_grep<cr>'},
       {'<leader>fb', ':Telescope buffers<cr>'},
       {'<leader>fh', ':Telescope help_tags<cr>'},
     },
     -- change some options
     opts = {
       defaults = {
         layout_strategy = "horizontal",
         layout_config = { prompt_position = "top" },
         sorting_strategy = "ascending",
         winblend = 0,
       },
       pickers = {
         find_files = {
           -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
           find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
         },
         live_grep = {
           find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
         },
       },
     },
   },
  "tpope/vim-obsession",
  "tpope/vim-repeat",
  "tpope/vim-surround",
}
