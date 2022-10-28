# cmp-graphql [WIP]

Neovim nvim-cmp source for graphql completions based on schema


### Instructions [WIP]

* Install `phenax/cmp-graphql` using your plugin manager
Example -
```lua
use 'phenax/cmp-graphql'
```

* Add graphql source to your cmp config
```lua
cmp.setup({
  sources = {
    // ...
    { name = 'graphql' }
  }
})
```

* Setup cmp-graphql for your project with
```lua
require('cmp-graphql').setup({
  schema_path = 'graphql.schema.json',
  path = { '[.]js$', '[.]ts$', '[.]gql$' }, 
})
```

