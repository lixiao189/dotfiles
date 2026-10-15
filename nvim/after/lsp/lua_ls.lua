-- lazydev.nvim replacement: when no .luarc.json exists, configure lua_ls for Neovim
-- (LuaJIT + the Neovim runtime + installed plugins).
---@type vim.lsp.Config
return {
  on_init = function(client)
    local root = client.workspace_folders and client.workspace_folders[1] and client.workspace_folders[1].name
    if
      root
      and root ~= vim.fn.stdpath("config")
      and (vim.uv.fs_stat(root .. "/.luarc.json") or vim.uv.fs_stat(root .. "/.luarc.jsonc"))
    then
      return
    end
    local library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" }
    for _, p in ipairs(vim.pack.get(nil, { info = false })) do
      library[#library + 1] = p.path
    end
    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua --[[@as table?]] or {}, {
      runtime = { version = "LuaJIT", path = { "lua/?.lua", "lua/?/init.lua" } },
      workspace = { checkThirdParty = false, library = library },
    })
  end,
  settings = {
    Lua = {
      completion = { callSnippet = "Replace" },
      hint = { enable = true, setType = false, paramType = true, arrayIndex = "Disable" },
    },
  },
}
