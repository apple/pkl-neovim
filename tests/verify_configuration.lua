--[[

    Copyright © 2026 Apple Inc. and the Pkl project authors. All rights reserved.

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
-- Verification harness for issue #74 (run with: make test)
-- Captures the settings table that pkl-neovim passes to vim.lsp.start(), then feeds it
-- through Neovim's REAL default workspace/configuration handler for the four sections
-- that pkl-lsp requests, and asserts every configured value is returned.

local plugin_root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
package.path = plugin_root .. "/lua/?.lua;" .. plugin_root .. "/lua/?/init.lua;" .. package.path

-- Provide a pkl-cli path and the other configurable settings.
vim.g.pkl_neovim = {
  start_command = { "true" },
  pkl_cli_path = "C:\\tools\\pkl.exe",
  pkl_formatter_grammar_version = "2",
  pkl_projects_excluded_directories = { ".git", "dist" },
  pkl_modulepath = { "modules" },
}

-- Capture the config table handed to vim.lsp.start (the real function would try to
-- spawn the pkl-lsp binary, which doesn't exist here).
local captured
vim.lsp.start = function(cfg)
  captured = cfg
  return 42
end

require("pkl-neovim").start_lsp()
assert(captured, "vim.lsp.start was never invoked")
assert(captured.settings, "no settings table was passed to the LSP client")

-- Hand the same settings table to the real default handler via a stub client.
vim.lsp.get_client_by_id = function(id)
  if id == 42 then
    return { id = id, settings = captured.settings }
  end
end

local handler = vim.lsp.handlers["workspace/configuration"]
assert(type(handler) == "function", "no default workspace/configuration handler")

local response = handler(nil, {
  items = {
    { section = "pkl.cli.path" },
    { section = "pkl.formatter.grammarVersion" },
    { section = "pkl.modulepath" },
    { section = "pkl.projects.excludedDirectories" },
  },
}, { client_id = 42, bufnr = 0, method = "workspace/configuration", params = {} })

local expected = {
  ["pkl.cli.path"] = "C:\\tools\\pkl.exe",
  ["pkl.formatter.grammarVersion"] = "2",
  ["pkl.modulepath"] = { "modules" },
  ["pkl.projects.excludedDirectories"] = { ".git", "dist" },
}
local sections = {
  "pkl.cli.path",
  "pkl.formatter.grammarVersion",
  "pkl.modulepath",
  "pkl.projects.excludedDirectories",
}

local failed = false
for i, section in ipairs(sections) do
  local got = response[i]
  local want = expected[section]
  local ok = vim.deep_equal(got, want)
  if not ok then
    failed = true
  end
  print(
    string.format(
      "%s %-40s -> %s (expected %s)",
      ok and "PASS" or "FAIL",
      section,
      vim.inspect(got),
      vim.inspect(want)
    )
  )
end

if failed then
  print("\nRESULT: sections return nil -- the configured values do not reach pkl-lsp")
  vim.cmd("cquit 1")
else
  print("\nRESULT: all configured values reach pkl-lsp through the default handler")
end
