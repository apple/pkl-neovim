-- Handlers responsible for executing commands.
-- These correspond to the `workspace/executeCommand` message, which gets fired by pkl-lsp
-- based on certain flows.
return {
  ["pkl.syncProjects"] = function (_, _)
    require("pkl-neovim").sync_projects()
  end,
  ["pkl.downloadPackage"] = function (cmd, _)
    assert(#cmd.arguments == 1, "Expected one argument")
    require("pkl-neovim").download_package(cmd.arguments[1])
  end
}
