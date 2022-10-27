require('cmp').setup({
  sources = { { name = 'graphql' } },
})

require('cmp-graphql').setup({
  schema_path = 'graphql.schema.json',
  path = { '[.]js$', '[.]ts$', '[.]gql$' }, 
})

vim.api.nvim_command [[ nmap <leader>tt :messages<cr> ]]
