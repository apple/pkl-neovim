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
local M = {}

---@class pklneovim.Config
---@field pkl_cli_path? string
---@field timeout_ms? integer
---@field start_command? string[]

---@param path string The path to the field being validated
---@param tbl table The table to validate
---@see vim.validate
---@return boolean is_valid
---@return string|nil error_message
local function validate_path(path, tbl)
  local ok, err = pcall(vim.validate, tbl)
  return ok, err and path .. "." .. err
end

local function validate(cfg)
  return validate_path("vim.g.pkl_neovim", {
    pkl_cli_path = { cfg.pkl_cli_path, {"string", "nil"} },
    timeout_ms = { cfg.timeout_ms, {"integer", "nil"} },
    start_command = { cfg.start_command, {"table", "nil"} }
  })
end

---@type pklneovim.Config | nil
vim.g.pkl_neovim = vim.g.pkl_neovim

---@return pklneovim.Config
function M.get_config()
  if not M._config then
    local user_config = vim.g.pkl_neovim or {}
    local ok, err = validate(user_config)
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
      return {}
    end
    M._config = user_config
  end
  return M._config
end

return M
