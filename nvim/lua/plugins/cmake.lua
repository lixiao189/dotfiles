-- Configure, build, run, and test via :CMake* commands.
-- Highlighting is treesitter "cmake"; diagnostics and completion are neocmake.
-- LazyVim's cmake extra does not bind keys, so neither does this.
-- `cmake` must be on PATH. compile_commands.json is symlinked to the project root for clangd.
--
-- Loaded only when needed: cmake-tools treats the cwd as the project, so a cwd with a
-- CMakeLists.txt (at startup or after :cd) or opening a cmake file pulls it in. Elsewhere
-- it would cost ~3ms of startup plus its session and DirChanged autocmds for nothing.
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
