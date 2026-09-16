-- Neovim wiring for scalino-lsp. Neovim 0.11+'s built-in LSP client is
-- generic enough that scalino only needs a client configuration.
local M = {}

local function is_executable(path)
  return vim.fn.executable(path) == 1
end

local function resolve_cmd(opts)
  opts = opts or {}

  if opts.path and opts.path ~= "" then
    if not is_executable(opts.path) then
      vim.notify(
        "scalino-lsp: configured path is not executable: " .. opts.path,
        vim.log.levels.ERROR
      )
    end
    return opts.path
  end

  if is_executable("scalino-lsp") then
    return "scalino-lsp"
  end

  vim.notify(
    "scalino-lsp not found on PATH -- skipping LSP setup",
    vim.log.levels.DEBUG
  )
  return nil
end

--- @param opts table|nil { path?: string, args?: string[], env?: table }
function M.setup(opts)
  opts = opts or {}
  local server = resolve_cmd(opts)
  if not server then
    return
  end

  local cmd = { server, unpack(opts.args or { "-stdio" }) }

  vim.lsp.config("scalino_lsp", {
    cmd = cmd,
    filetypes = { "scala" },
    root_markers = { ".scalino-build", ".git" },
    cmd_env = opts.env,
  })
  vim.lsp.enable("scalino_lsp")
end

return M
