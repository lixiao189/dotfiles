local util = require("config.util")

---@param dir? string
local function explorer(dir)
  return function()
    require("neo-tree.command").execute({ toggle = true, dir = dir })
  end
end

---@param source string
local function source(source)
  return function()
    require("neo-tree.command").execute({ source = source, toggle = true })
  end
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-mini/mini.icons",
    },
    keys = {
      { "<leader>e", explorer(util.root()), desc = "Explorer NeoTree (Root Dir)" },
      { "<leader>E", explorer(), desc = "Explorer NeoTree (cwd)" },
      { "<leader>fe", explorer(util.root()), desc = "Explorer NeoTree (Root Dir)" },
      { "<leader>fE", explorer(), desc = "Explorer NeoTree (cwd)" },
      { "<leader>be", source("buffers"), desc = "Buffer Explorer" },
      { "<leader>ge", source("git_status"), desc = "Git Explorer" },
    },
    init = function()
      -- Open the tree on `nvim <dir>` instead of a netrw-less empty buffer.
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("config_neotree_start_directory", { clear = true }),
        desc = "Start Neo-tree with directory",
        once = true,
        callback = function()
          if package.loaded["neo-tree"] then
            return
          end
          local stats = vim.uv.fs_stat(vim.fn.argv(0))
          if stats and stats.type == "directory" then
            require("neo-tree")
          end
        end,
      })
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "qf", "toggleterm", "neo-tree" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = { visible = false, hide_dotfiles = false, hide_gitignored = false },
      },
      window = {
        width = 30,
        mappings = {
          ["l"] = "open",
          ["h"] = "close_node",
          ["<space>"] = "none",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              vim.fn.setreg("+", node:get_id(), "c")
            end,
            desc = "Copy Path to Clipboard",
          },
          ["O"] = {
            function(state)
              vim.ui.open(state.tree:get_node().path)
            end,
            desc = "Open with System Application",
          },
          ["P"] = { "toggle_preview", config = { use_float = false } },
          ["H"] = "toggle_hidden",
          ["/"] = "fuzzy_finder",
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        git_status = { symbols = { unstaged = "", staged = "" } },
      },
    },
    config = function(_, opts)
      -- Keep already-open buffers pointing at the new path after a move/rename.
      local function on_move(data)
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) == data.source then
            vim.api.nvim_buf_set_name(buf, data.destination)
          end
        end
      end

      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
      require("neo-tree").setup(opts)
    end,
  },
}
