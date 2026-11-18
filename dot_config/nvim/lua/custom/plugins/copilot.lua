local gh = function(x) return 'https://github.com/' .. x end

vim.pack.add { 
  { src = gh 'zbirenbaum/copilot.lua' },
  { src = gh 'giuxtaposition/blink-cmp-copilot' }, 
}

require('copilot').setup {
  suggestion = { enabled = false },
  panel = { enabled = false },
}
