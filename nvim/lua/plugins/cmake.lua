-- Configure, build, run, and test via :CMake* commands.
-- Highlighting is treesitter "cmake"; diagnostics and completion are neocmake.
-- LazyVim's cmake extra does not bind keys, so neither does this.
-- `cmake` must be on PATH. compile_commands.json is symlinked to the project root for clangd.
require("cmake-tools").setup({
  cmake_build_directory = "build/${variant:buildType}",
})
