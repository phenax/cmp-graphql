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
    -- 63 == graphql's document node
    if parent:symbol() == 63 then return true end
    parent = parent:parent()
  end
  return false
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

function source._get_field_path(self, node, bufnr, path)
  path = path or {}

  if node == nil then return path end

  if node:type() == "operation_definition" then
    local schema = self:_get_schema()
    local op_type_name = vim.treesitter.get_node_text(node:child(0), bufnr)
    table.insert(path, 1, schema[op_type_name .. "Type"].name)
    return path
  end

  if node:type() == "inline_fragment" then
    local frag_name = vim.treesitter.get_node_text(node:child(1):child(1), bufnr)
    table.insert(path, 1, frag_name)
    return path
  end

  if node:type() == "fragment_definition" then
    local frag_name = vim.treesitter.get_node_text(node:child(2):child(1), bufnr)
    table.insert(path, 1, frag_name)
  end

  if node:type() == "field" then
    local field_name = vim.treesitter.get_node_text(node:child(0), bufnr)
    table.insert(path, 1, field_name)
  end

  return self:_get_field_path(node:parent(), bufnr, path)
end

function source._get_fields(self, path)
  local schema = self:_get_schema()
  local type = schema

  for _, key in pairs(path) do
    local fields = type.fields or type.types or {}

    local field = util.find_in_table(fields, function(t) return t.name == key end)
    if field == nil then return {} end

    if field.type ~= nil then
      local ty_name = util.collapse_type(field.type)
      type = util.find_in_table(schema.types, function(t) return t.name == ty_name end)
    else
      type = field
    end

    if type == nil then return {} end
  end

  if type.fields == vim.NIL then return {} end
  return type.fields or {}
end

---@param params cmp.SourceCompletionApiParams
---@param callback fun(response: lsp.CompletionResponse|nil)
function source.complete(self, params, callback)
  vim.defer_fn(function()
    local bufnr = vim.fn.bufnr('%')
    local node = util.get_ts_node_under_cursor()

    local field_path = self:_get_field_path(node, bufnr)
    local fields = self:_get_fields(field_path)

    callback(vim.tbl_map(function(field)
      local has_fields = util.is_of_kind("OBJECT", field.type)
      local required_args = vim.tbl_filter(function(arg)
        return util.is_of_kind("NON_NULL", arg.type)
      end, field.args or {})
      local has_required_args = vim.tbl_count(required_args) > 0

      local arg_string = table.concat(
        vim.tbl_map(
          function(a) return a.name .. ": " end,
          required_args
        ),
      ",")

      return {
        label = field.name,
        kind = cmp_lsp.CompletionItemKind.Field,
        insertText = field.name
          .. util.if_else(has_required_args, "(" .. arg_string .. ")", "")
          .. util.if_else(has_fields, " {}", ""),
        detail = "field",
        documentation = field.description,
      }
    end, fields))
  end, 0)
end

return source
