local cmp_gql = require('cmp-gql')

require('cmp').register_source('gql', cmp_gql.new())

require('cmp').setup({
  sources = { { name = 'gql' } },
})
