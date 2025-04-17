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
---@enum MessageType
local messageType = {
  error = 1,
  warning = 2,
  info = 3,
  log = 4,
  debug = 5,
}

---@class Command
---@field title string    Title of the command, like `save`.
---@field command string  The identifier of the actual command handler.
---@field arguments any[] Arguments that the command handler should be invoked with.

---@class ActionableNotification
---@field type MessageType
---@field message string
---@field data any
---@field commands Command[]

---@param type MessageType
local function get_prefix(type)
  local prefixes = {
    [messageType.error] = "[ERROR] ",
    [messageType.warning] = "[WARNING] "
  }
  return prefixes[type] or ""
end

---@param notification ActionableNotification
local function actionable_notification_handler(_, notification, ctx)
  local commands_iter = vim.iter(notification.commands)

  local titles = commands_iter
    :map(function (it) return it.title end)
    :to_table()

  local client = vim.lsp.clients.find_by_id(ctx.client_id)
  if not client then
    return
  end

  vim.ui.select(
    titles,
    {
      prompt = get_prefix(notification.type) .. notification.message
    },
    function (response)
      if not response then
        return
      end
      local command = commands_iter
        :find(function (it) return it.title == response end)
      if not command then
        return
      end
      client:exec_cmd(command, { bufnr = ctx.bufnr })
    end
  )
end

return {
  ["pkl/actionableNotification"] = actionable_notification_handler
}
