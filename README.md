# cmp-graphql

Neovim nvim-cmp source for graphql completions based on schema


### Instructions

* Install `phenax/cmp-graphql` using your plugin manager
Example -
```lua
use 'phenax/cmp-graphql'
```

* Setup cmp for your project with
```lua
require('cmp-gql').setup({
  schema_path = 'graphql.schema.json',
  path = { '[.]js$', '[.]ts$', '[.]gql$' }, 
})
```

