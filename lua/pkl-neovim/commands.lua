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

---@class PklSubcommand
---@field impl fun(args: string[], opts: table) The command implementation
---@field complete? fun(subcmd_arg_lead: string): string[] Command completions callback, taking the lead of the subcommand's arguments

---@type table<string, PklSubcommand>
local subcommand_tbl = {
  syncProjects = {
    impl = function (args, opts)
      local plugin = require('pkl-neovim')
      plugin.sync_projects()
    end
  }
}

---@param opts table :h lua-guide-commands-create
local function pkl_command(opts)
  local fargs = opts.fargs
  local subcommand_key = fargs[1]
  local args = #fargs > 1 and vim.list_slice(fargs, 2, #fargs) or {}
  local subcommand = subcommand_tbl[subcommand_key]
  if not subcommand then
    vim.notify("Pkl: Unknown command: " .. subcommand_key, vim.log.levels.ERROR)
    return
  end
  subcommand.impl(args, opts)
end

M.register = function()
  api.nvim_create_user_command(
    "Pkl",
    pkl_command,
    {
      nargs = "+",
      desc = "Commands related to working with Pkl",
      complete = function(arg_lead, cmdline, _)
        -- Get the subcommand.
        local subcmd_key, subcmd_arg_lead = cmdline:match("^['<,'>]*Pkl[!]*%s(%S+)%s(.*)$")
        if subcmd_key
          and subcmd_arg_lead
          and subcommand_tbl[subcmd_key]
          and subcommand_tbl[subcmd_key].complete
        then
          -- The subcommand has completions. Return them.
          return subcommand_tbl[subcmd_key].complete(subcmd_arg_lead)
        end
        -- Check if cmdline is a subcommand
        if cmdline:match("^['<,'>]*Pkl[!]*%s+%w*$") then
          -- Filter subcommands that match
          local subcommand_keys = vim.tbl_keys(subcommand_tbl)
          return vim.iter(subcommand_keys)
            :filter(function(key)
                return key:find(arg_lead) ~= nil
            end)
            :totable()
        end
      end,
    }
  )
end

return M
