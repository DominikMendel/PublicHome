return {
  "stevearc/oil.nvim",
  lazy = false,
  -- My config
  opts = function(_, opts)
    return require("astrocore").extend_tbl(opts, {
      default_file_explorer = true,
      keymaps = {
        -- TODO: How to add a file or directory
        ["?"] = "actions.show_help",
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-CR>"] = {
          "actions.select",
          opts = { vertical = true },
          desc = "Open the entry in a vertical split",
        },
        ["<C-S-/>"] = {
          "actions.select",
          opts = { horizontal = true },
          desc = "Open the entry in a horizontal split",
        },
        ["C-h"] = false,
        ["C-j"] = false,
        ["C-k"] = false,
        ["C-l"] = false,
        ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        -- ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
      use_default_keymaps = false,
      view_options = {
        show_hidden = true,
      },
    })
  end,

  -- Remove Neotree for Oil
  init = function() -- start oil on startup lazily if necessary
    if vim.fn.argc() == 1 then
      local arg = vim.fn.argv(0)
      ---@cast arg string
      local stat = (vim.uv or vim.loop).fs_stat(arg)
      local adapter = string.match(arg, "^([%l-]*)://")
      if (stat and stat.type == "directory") or adapter == "oil-ssh" then require("oil") end
    end
  end,
  specs = {
    { "nvim-neo-tree/neo-tree.nvim", optional = true, opts = { filesystem = { hijack_netrw_behavior = "disabled" } } },
    {
      "AstroNvim/astrocore",
      opts = {
        autocmds = {
          neotree_start = false,
          oil_start = {
            {
              event = "BufNew",
              desc = "start oil when editing a directory",
              callback = function()
                if package.loaded["oil"] then
                  vim.api.nvim_del_augroup_by_name("oil_start")
                elseif vim.fn.isdirectory(vim.fn.expand("<afile>")) == 1 then
                  require("oil")
                  vim.api.nvim_del_augroup_by_name("oil_start")
                end
              end,
            },
          },
        },
      },
    },
  },
}
