
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

return util
