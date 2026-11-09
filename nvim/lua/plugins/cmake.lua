-- :CMake* commands. Needs `cmake` on PATH; compile_commands.json is symlinked to the root for clangd.
-- cmake-tools treats the cwd as the project, so it loads for a cwd with a CMakeLists.txt
-- (at startup or after :cd) or a cmake file.
local function in_cmake_project()
  return vim.uv.fs_stat(vim.fn.getcwd() .. "/CMakeLists.txt") ~= nil
end

return {
  "Civitasv/cmake-tools.nvim",
  lazy = not in_cmake_project(),
  ft = "cmake",
  dependencies = { "nvim-lua/plenary.nvim" },
  init = function()
    vim.api.nvim_create_autocmd("DirChanged", {
      group = vim.api.nvim_create_augroup("config_cmake", { clear = true }),
      callback = function()
        if in_cmake_project() then
          require("lazy").load({ plugins = { "cmake-tools.nvim" } })
          return true
        end
      end,
    })
  end,
  opts = { cmake_build_directory = "build/${variant:buildType}" },
}
