local cmp_lsp = require('cmp.types.lsp')
local util = require('cmp-gql.util')

local source = {}

function source.new()
  local self = setmetatable({}, { __index = source })
  return self
end

---@return boolean
function source.is_available()
  local node = util.get_ts_node_under_cursor()
  if node == nil then return false end

  local parent = node:parent()
  while parent ~= nil do
    if parent:type() == "document" then return true end
    parent = parent:parent()
  end
  return false
end

local function get_operation_type(node, bufnr)
  if node == nil then return nil end
  if node:type() == 'operation_definition' then
    return vim.treesitter.get_node_text(node:child(0), bufnr)
  end

  return get_operation_type(node:parent(), bufnr)
end

---@param params cmp.SourceCompletionApiParams
---@param callback fun(response: lsp.CompletionResponse|nil)
function source.complete(self, params, callback)
  -- get current node
  -- if selection_set,
  --    check the ancestor -> operation_definition
  --      -> operation_definition.operation_type -> mutation, fields inside mutation type
  --      -> field -> 
  vim.defer_fn(function()
    local bufnr = vim.fn.bufnr('%')
    local node = util.get_ts_node_under_cursor()
    local op_type = get_operation_type(node, bufnr)

    callback({
      {
        label = 'january',
        kind = cmp_lsp.CompletionItemKind.Field,
        insertText = 'januaryAsAField',
        documentation = 'This is the fields description',
        detail = 'This is a field',
      },
    })
  end, 0)
end

return source
