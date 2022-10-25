
local util = {}

function util.get_ts_node_under_cursor()
  local bufnr = vim.fn.bufnr('%')
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return vim.treesitter.get_node_at_pos(
    bufnr,
    line - 1,
    col,
    { ignore_injections = false }
  )
end

function util.if_else(p, a, b)
  if p then return a else return b end
end

function util.find_in_table(table, fn)
  for _, item in pairs(table) do
    if fn(item) then return item end
  end

  return nil
end

function util.collapse_type(type)
  if type == nil then return nil end
  if type.ofType == vim.NIL then return type.name end
  return util.collapse_type(type.ofType)
end

function util.is_of_kind(kind, type)
  if type == nil or type == vim.NIL then return false end
  if type.kind == kind then
    return true
  end
  return util.is_of_kind(kind, type.ofType)
end

return util
