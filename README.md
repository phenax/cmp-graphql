# cmp-graphql [WIP]

Neovim nvim-cmp source for graphql completions based on schema


## Instructions [WIP]

#### Install `phenax/cmp-graphql` using your plugin manager
Example -
```lua
use 'phenax/cmp-graphql'
```

#### Add graphql source to your cmp config
```lua
cmp.setup({
  -- ...
  sources = {
    -- ...
    { name = 'graphql' }
  }
})
```

#### Generate schema json file (Using [@graphql-codegen/cli](https://github.com/dotansimha/graphql-code-generator))

Run codegen init to setup the codegen config file
```shell
yarn graphql-codegen init
```

Make sure introspection json is enabled

And then

```shell
yarn && yarn codegen
```

#### Setup cmp-graphql for your project with
```lua
require('cmp-graphql').setup({
  schema_path = 'graphql.schema.json', -- Path to generated json schema file in project
})
```

