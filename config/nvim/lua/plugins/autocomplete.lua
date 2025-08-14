return {
  -- Language server protocol
  {
      "mason-org/mason-lspconfig.nvim",
      opts = {},
      dependencies = {
          { "mason-org/mason.nvim", opts = {} },
          "neovim/nvim-lspconfig",
      },
  },
  -- Autocomplete
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    lazy = false,
    branch = master,
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "comment",
        "cpp",
        "css",
        "dockerfile",
        "go",
        "json",
        "lua",
        "make",
        "markdown",
        "python",
        "ruby",
        "rust",
        "scss",
        "sql",
        "yaml",
      },
      highlight = {
        enable = true,  -- false will disable the whole extension
        disable = {},  -- list of language that will be disabled
      },
    },
  },
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/nvim-cmp',
  'hrsh7th/vim-vsnip',
  'hrsh7th/vim-vsnip-integ',
}
