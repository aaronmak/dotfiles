vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'          -- Let packer manage itself
  use 'christoomey/vim-tmux-navigator'  -- Easier navigation between tmux and vim

  -- Convenience
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use 'junegunn/vim-easy-align'
  use 'justinmk/vim-sneak'
  use 'tomtom/tcomment_vim'
  use 'tpope/vim-abolish'
  use 'tpope/vim-endwise'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-obsession'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'

  -- Improve display
  use 'sunjon/shade.nvim'
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
  }
  use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}
  use {
    'nvim-lualine/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }
  use 'lukas-reineke/indent-blankline.nvim'
  use 'sainnhe/gruvbox-material'

  -- Language server protocol
  use 'neovim/nvim-lspconfig'

  -- Autocomplete
  use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate'
  }
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/vim-vsnip-integ'
  use "rafamadriz/friendly-snippets"

  -- Formatting with editor config
  use 'editorconfig/editorconfig-vim'

  -- Collaborative editing
  use 'jbyuki/instant.nvim'
end)
