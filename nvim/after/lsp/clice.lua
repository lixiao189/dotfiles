---@type vim.lsp.Config
return {
  filetypes = { "c", "cpp", "c.doxygen", "cpp.doxygen", "cuda" },
  get_language_id = function(_, filetype)
    return (filetype:gsub("%.doxygen$", ""))
  end,
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, {
      function(name, dir)
        return name == "clice.toml"
          or (name == ".clice" and vim.uv.fs_stat(vim.fs.joinpath(dir, name, "config.toml")) ~= nil)
      end,
      "compile_commands.json",
      ".git",
      { "CMakeLists.txt", "Makefile", "meson.build" },
    })
    on_dir(root)
  end,
}
