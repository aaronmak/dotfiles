return {
  -- Language server protocol
  'neovim/nvim-lspconfig',

  -- Autocomplete
  {
     'nvim-treesitter/nvim-treesitter',
     build = ':TSUpdate',
  },
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/nvim-cmp',
  'hrsh7th/vim-vsnip',
  'hrsh7th/vim-vsnip-integ',
}
