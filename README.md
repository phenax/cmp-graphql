# cmp-graphql [WIP]

Neovim nvim-cmp source for graphql completions based on schema


## Instructions [WIP]

### Install `phenax/cmp-graphql` using your plugin manager
Example -
```lua
use 'phenax/cmp-graphql'
```

### Add graphql source to your cmp config
```lua
cmp.setup({
  -- ...
  sources = {
    -- ...
    { name = 'graphql' }
  }
})
```

### Generate schema json file (Using [@graphql-codegen/cli](https://github.com/dotansimha/graphql-code-generator))

* Install `@graphql-codegen/cli`
```shell
yarn add -D @graphql-codegen/cli
```

* Run codegen init to setup the codegen config file

NOTE: Make sure introspection json is enabled. The only relevant generated file is the schema json file.
```shell
yarn graphql-codegen init
```

* And then to generate the schema json file

```shell
yarn && yarn codegen
```

### Setup cmp-graphql for your project with
```lua
require('cmp-graphql').setup({
  schema_path = 'graphql.schema.json', -- Path to generated json schema file in project
})
```

