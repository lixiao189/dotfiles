return {
  {
    "avante-corp/avante.nvim",
    event = "VeryLazy",
    version = false,
    build = "make",
    opts = function()
      local function required(name)
        local value = vim.env[name]
        assert(value and value ~= "", "Set " .. name .. " in ~/.zshrc.local before starting Neovim")
        return value
      end
      return {
        provider = "openai",
        providers = {
          -- The built-in openai provider keeps its default api_key_name, so the key
          -- comes from AVANTE_OPENAI_API_KEY (scoped) or OPENAI_API_KEY.
          openai = {
            endpoint = required("AVANTE_API_URL"),
            model = required("AVANTE_MODEL"),
            context_window = tonumber(vim.env.AVANTE_CONTEXT_WINDOW),
            extra_request_body = {
              max_completion_tokens = tonumber(vim.env.AVANTE_MAX_TOKENS),
              reasoning_effort = vim.env.AVANTE_REASONING_EFFORT,
            },
          },
        },
        behaviour = { auto_set_keymaps = false },
        selection = { hint_display = "none" },
        input = { provider = "dressing" },
        -- fzf-lua previews lazily, so opening @file does not read every project file.
        selector = { provider = "fzf_lua" },
      }
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      { "ColinKennedy/mega.cmdparse", dependencies = { "ColinKennedy/mega.logging" } },
      "hrsh7th/nvim-cmp",
      "ibhagwan/fzf-lua",
      "stevearc/dressing.nvim",
      "nvim-mini/mini.icons",
      "MeanderingProgrammer/render-markdown.nvim",
    },
    keys = {
      { "<leader>aa", "<cmd>AvanteAsk<cr>", mode = { "n", "x" }, desc = "Ask Avante" },
      { "<leader>ac", "<cmd>AvanteChat<cr>", desc = "Chat with Avante" },
      { "<leader>ae", ":AvanteEdit<cr>", mode = { "n", "x" }, desc = "Edit Avante" },
      { "<leader>af", "<cmd>AvanteFocus<cr>", desc = "Focus Avante" },
      { "<leader>ah", "<cmd>Avante resume<cr>", desc = "Avante History" },
      { "<leader>am", "<cmd>AvanteModels<cr>", desc = "Select Avante Model" },
      { "<leader>an", "<cmd>AvanteChatNew<cr>", desc = "New Avante Chat" },
      { "<leader>ap", "<cmd>AvanteSwitchProvider<cr>", desc = "Switch Avante Provider" },
      { "<leader>ar", "<cmd>AvanteRefresh<cr>", desc = "Refresh Avante" },
      { "<leader>as", "<cmd>AvanteStop<cr>", desc = "Stop Avante" },
      { "<leader>at", "<cmd>Avante toggle<cr>", desc = "Toggle Avante" },
    },
  },
}
