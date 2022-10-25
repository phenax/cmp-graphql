require('cmp').setup({
  sources = { { name = 'gql' } },
})

require('cmp-gql').setup({
  schema_path = 'graphql.schema.json',
  path = { '*.js', '*.ts', '*.gql' }, 
})

vim.api.nvim_command [[ nmap <leader>tt :messages<cr> ]]
