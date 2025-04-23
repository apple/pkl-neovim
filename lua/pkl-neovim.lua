--[[

    Copyright © 2025 Apple Inc. and the Pkl project authors. All rights reserved.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

]]
local api = vim.api

local M = {}

local function get_lsp_client()
  for _, c in ipairs(vim.lsp.get_clients()) do
    if c.name == "pkl" then
      return c
    end
  end
end

local function get_or_start_lsp_client()
  local client = get_lsp_client()
  if not client then
    M.start_lsp()
  end
  client = get_lsp_client()
  assert(client, "Pkl LSP client is not started")
  return client
end

function M.init()
  M.init_grammar()
  require("pkl-neovim.commands").register()
end

function M.init_grammar()
  local treesitterExists, parsers = pcall(require, "nvim-treesitter.parsers")
  local _, installer = pcall(require, "nvim-treesitter.install")
  if treesitterExists then
    parsers.get_parser_configs().pkl = {
      install_info = {
        url = "https://github.com/apple/tree-sitter-pkl.git",
        revision = "v0.18.1",
        files = {"src/parser.c", "src/scanner.c"},
        filetype = "pkl",
        used_by = {"pcf"}
      },
    }

    if not parsers.has_parser("pkl") then
      installer.update("pkl")
    end
  else
    print("[pkl-neovim] Required plugin 'tree-sitter/tree-sitter' not found.")
    print("             Ensure that it is installed in order to receive features such as syntax highlighting and code folding.")
  end
end

---Starts the Pkl LSP, if not already started.
---No-op if the start command is not configured.
function M.start_lsp()
  local config = require("pkl-neovim.config").get_config()
  if not config.start_command then
    vim.notify_once("Configuration `vim.g.pkl_neovim.start_command` is not set; Pkl LSP features are not enabled.", vim.log.levels.WARN)
    return
  end
  vim.lsp.start({
    name = 'pkl',
    settings = {
      ["pkl.cli.path"] = config.pkl_cli_path
    },
    -- first look for a `.pkl-lsp` dir
    -- failing that, look for a `.git` dir
    -- failing that, look for a PklProject file
    root_dir =
      vim.fs.root(0, '.pkl-lsp')
        or vim.fs.root(0, '.git')
        or vim.fs.root(0, 'PklProject'),
    cmd = config.start_command,
    handlers = require("pkl-neovim.lsp_extensions"),
    commands = require("pkl-neovim.lsp_commands"),
    init_options = {
      extendedClientCapabilities = {
        actionableRuntimeNotifications = true
      }
    }
  })
end

---Opens the provided `pkl-lsp://` scheme file in the current buffer.
---
---@param fname string URI of the file to open
function M.open_lspfile(fname)
  local client = get_lsp_client()
  local config = require("pkl-neovim.config").get_config()
  assert(client, "No Pkl LSP instance found attached to the current buffer")
  local timeout_ms = config.timeout_ms or 5000
  local buf = api.nvim_get_current_buf()
  vim.bo[buf].modifiable = true
  vim.bo[buf].swapfile = false
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].filetype = 'pkl'
  local content
  local function handler(err, result)
    assert(not err, vim.inspect(err))
    content = result
    local normalized = string.gsub(result, '\r\n', '\n')
    local source_lines = vim.split(normalized, "\n", { plain = true })

    api.nvim_buf_set_lines(buf, 0, -1, false, source_lines)
    vim.bo[buf].modifiable = false
  end
  client:request("pkl/fileContents", { uri = fname }, handler, buf)
  -- Need to block. Otherwise logic could run that sets the cursor to a position
  -- that's still missing.
  vim.wait(timeout_ms, function() return content ~= nil end)
end

---Tells the existing Pkl LSP to run the syncProjects action.
---Scans the workspace directories for PklProject files, and creates a graph of dependencies.
function M.sync_projects()
  local client = get_or_start_lsp_client()
  assert(client, "No Pkl LSP instance found attached to the current buffer")
  local buf = api.nvim_get_current_buf()
  client:request("pkl/syncProjects", nil, function() end, buf)
end

---Tells the LSP to download the specified package.
---This requires that `vim.g.pkl_neovim.pkl_cli_path` has been set to the Pkl executable.
---@param packageUri string
function M.download_package(packageUri)
  local client = get_or_start_lsp_client()
  assert(client, "No Pkl LSP instance found attached to the current buffer")
  local buf = api.nvim_get_current_buf()
  client:request("pkl/downloadPackage", packageUri, function() end, buf)
end

return M
