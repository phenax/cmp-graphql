local cmp = require('cmp')
local compl = require('cmp-gql.cmp')

local M = {}

function M.setup(config)
  cmp.register_source('gql', compl.new(config))
end

return M

