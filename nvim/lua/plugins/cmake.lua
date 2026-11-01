-- Configure, build, run, and test. Highlighting is treesitter "cmake";
-- diagnostics and completion are neocmake (see plugins/lsp.lua).
-- Dialogs use vim.ui.select, which Snacks already owns. `cmake` must be on PATH.
require("cmake-tools").setup({
  -- clangd searches the project root. The plugin symlinks compile_commands.json there.
  cmake_build_directory = "build/${variant:buildType}",
})

local map = vim.keymap.set
map("n", "<leader>mg", "<cmd>CMakeGenerate<cr>", { desc = "Configure" })
map("n", "<leader>mG", "<cmd>CMakeGenerate!<cr>", { desc = "Clean and Configure" })
map("n", "<leader>mb", "<cmd>CMakeBuild<cr>", { desc = "Build" })
map("n", "<leader>mB", "<cmd>CMakeBuild!<cr>", { desc = "Clean and Build" })
map("n", "<leader>mf", "<cmd>CMakeBuildCurrentFile<cr>", { desc = "Build Current File" })
map("n", "<leader>mr", "<cmd>CMakeRun<cr>", { desc = "Run" })
map("n", "<leader>mR", "<cmd>CMakeRunCurrentFile<cr>", { desc = "Run Current File" })
map("n", "<leader>mt", "<cmd>CMakeRunTest<cr>", { desc = "Test" })
map("n", "<leader>mx", "<cmd>CMakeStopExecutor<cr>", { desc = "Stop Build" })
map("n", "<leader>mX", "<cmd>CMakeStopRunner<cr>", { desc = "Stop Run" })
map("n", "<leader>mc", "<cmd>CMakeClean<cr>", { desc = "Clean" })
map("n", "<leader>mi", "<cmd>CMakeInstall<cr>", { desc = "Install" })
map("n", "<leader>mo", "<cmd>CMakeSelectBuildTarget<cr>", { desc = "Select Build Target" })
map("n", "<leader>ml", "<cmd>CMakeSelectLaunchTarget<cr>", { desc = "Select Launch Target" })
map("n", "<leader>my", "<cmd>CMakeSelectBuildType<cr>", { desc = "Select Build Type" })
map("n", "<leader>mp", "<cmd>CMakeSelectConfigurePreset<cr>", { desc = "Select Configure Preset" })
map("n", "<leader>mP", "<cmd>CMakeSelectBuildPreset<cr>", { desc = "Select Build Preset" })
map("n", "<leader>mT", "<cmd>CMakeSelectTestPreset<cr>", { desc = "Select Test Preset" })
map("n", "<leader>ma", "<cmd>CMakeLaunchArgs<cr>", { desc = "Launch Args" })
map("n", "<leader>mk", "<cmd>CMakeSelectKit<cr>", { desc = "Select Kit" })
map("n", "<leader>mq", "<cmd>CMakeQuickStart<cr>", { desc = "New Project" })
