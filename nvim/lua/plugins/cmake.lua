-- :CMake* commands. Needs `cmake` on PATH; compile_commands.json is symlinked to the root for clangd.
-- cmake-tools treats the cwd as the project, so it loads only for a cwd with a CMakeLists.txt
-- (at startup or after :cd) or a cmake file; elsewhere it would cost ~3ms of startup.
local group = vim.api.nvim_create_augroup("config_cmake", { clear = true })

local function load()
  vim.api.nvim_del_augroup_by_id(group)
  vim.cmd.packadd("plenary.nvim")
  vim.cmd.packadd("cmake-tools.nvim")
  require("cmake-tools").setup({
    cmake_build_directory = "build/${variant:buildType}",
  })
end

local function in_cmake_project()
  return vim.uv.fs_stat(vim.fn.getcwd() .. "/CMakeLists.txt") ~= nil
end

if in_cmake_project() then
  load()
else
  vim.api.nvim_create_autocmd("DirChanged", {
    group = group,
    callback = function()
      if in_cmake_project() then
        load()
      end
    end,
  })
  vim.api.nvim_create_autocmd("FileType", { group = group, pattern = "cmake", once = true, callback = load })
end
