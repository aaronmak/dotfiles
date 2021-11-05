vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'      -- Let packer manage itself
  use 'neovim/nvim-lspconfig'          -- lsp common config
  use 'hrsh7th/nvim-cmp'               -- completion engine for neovim
  use 'christoomey/vim-tmux-navigator'

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
  use 'blueyed/vim-diminactive'
  use 'airblade/vim-gitgutter'
  use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}
  use 'lukas-reineke/indent-blankline.nvim'

  -- Autocomplete
  use {'Shougo/deoplete.nvim', run = ':UpdateRemotePlugins'}
  use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate'
  }
  use 'christianchiarulli/nvcode-color-schemes.vim'

  -- Python
  use 'deoplete-plugins/deoplete-jedi'
  use 'psf/black'

  -- Formatting with editor config
  use 'editorconfig/editorconfig-vim'
end)
