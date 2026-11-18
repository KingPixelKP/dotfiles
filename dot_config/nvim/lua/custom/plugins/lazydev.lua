local gh = function(x) return 'https://github.com/' .. x end

vim.pack.add {
  { src = gh 'folke/lazydev.nvim' },
}

require('lazydev').setup {
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}
