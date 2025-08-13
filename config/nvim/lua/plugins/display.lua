return {
   'TaDaa/vimade',
   {
     'lewis6991/gitsigns.nvim',
     dependencies = {
       'nvim-lua/plenary.nvim'
     },
   },
   {
     'akinsho/bufferline.nvim',
     version = "*",
     dependencies = 'kyazdani42/nvim-web-devicons'
   },
   {
     'nvim-lualine/lualine.nvim',
     dependencies = {'kyazdani42/nvim-web-devicons', lazy = true}
   },
   'lukas-reineke/indent-blankline.nvim',
   'folke/tokyonight.nvim',
}
