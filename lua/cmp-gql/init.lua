local cmp_lsp = require('cmp.types.lsp')
local util = require('cmp-gql.util')

local source = {}

function source.new()
  local self = setmetatable({}, { __index = source })
  self._schema = nil
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

function source._get_schema(self)
  if self._schema ~= nil then return self._schema end
  
  local file_path = vim.loop.cwd() .. '/graphql.schema.json'

  local fd = assert(vim.loop.fs_open(file_path, 'r', 438))
  local stat = assert(vim.loop.fs_stat(file_path))
  local contents = assert(vim.loop.fs_read(fd, stat.size, 0))
  local schema = vim.json.decode(contents).__schema
  self._schema = schema

  return schema
end

---@param params cmp.SourceCompletionApiParams
---@param callback fun(response: lsp.CompletionResponse|nil)
function source.complete(self, params, callback)
  vim.defer_fn(function()
    local bufnr = vim.fn.bufnr('%')
    local node = util.get_ts_node_under_cursor()
    local op_type = get_operation_type(node, bufnr)
    local schema = self:_get_schema()
    local op_type_name = schema[op_type .. 'Type'].name

    if node:parent():type() == "operation_definition" then
      local matching_fields = {}
      for _, ty in pairs(schema.types) do
        if ty.kind == 'OBJECT' and ty.name == op_type_name then
          for _, field in pairs(ty.fields) do
            local item = {
              label = field.name,
              kind = cmp_lsp.CompletionItemKind.Field,
              insertText = field.name,
              detail = "field",
              documentation = field.description,
            }
            table.insert(matching_fields, item)
          end
        end
      end

      callback(matching_fields)
      return
    end

    callback({
      {
        label = 'january:' .. op_type,
        kind = cmp_lsp.CompletionItemKind.Field,
        insertText = 'januaryAsAField',
        detail = op_type,
        documentation = 'This is the fields description',
      },
    })
  end, 0)
end

return source
