local cmp = require('cmp')
local compl = require('cmp-graphql.cmp')

local M = {}

function M.setup(config)
  cmp.register_source('graphql', compl.new(config))
end

return M

