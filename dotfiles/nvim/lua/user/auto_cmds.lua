local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- File type associations
autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.tf',
  command = 'setf terraform'
})
autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.tpl',
  command = 'setf json'
})
