local telescope_opts = function(_, opts)
  local layout_actions = require("telescope.actions.layout")
  local actions = require("telescope.actions")
  local actions_state = require("telescope.actions.state")

  local function open_parent_in_oil(bufnr)
    local selection = actions_state.get_selected_entry().value
    actions.close(bufnr)
    local parent_dir = vim.fn.fnamemodify(selection, ":h")
    require("oil").open(parent_dir)
  end
  local file_browser_actions = require("telescope._extensions.file_browser.actions")

  return require("astrocore").extend_tbl(opts, {
    defaults = {
      -- sorting_strategy = "ascending",
      mappings = {
        i = {
          -- ['<c-enter>'] = 'to_fuzzy_refine' },
          ["<C-j>"] = "move_selection_next",
          -- TODO: This works but need to fix the keybind
          -- ["<C-j>"] = open_parent_in_oil,
          ["<C-k>"] = "move_selection_previous",
          ["<C-g>"] = "close",
          ["<C-CR>"] = "select_vertical",
          ["<C-S-/>"] = "select_horizontal",
          -- Browser extension
          -- BUG: This removes the mark for selection behavior
          -- Do I really want this for Browser extension?
          ["<Tab>"] = "select_default",
        },
        n = {
          ["q"] = "close",
          ["<C-g>"] = "close",
          ["<C-CR>"] = "select_vertical",
          ["<C-S-/>"] = "select_horizontal",

          -- Browser extension
          ["-"] = file_browser_actions.goto_parent_dir,
          ["<Tab>"] = "select_default",
        },
      },

      path_display = { "smart" }, -- Make path files relative and shorter

      -- See telescope.layout.vertical()
      layout_strategy = "vertical",
      -- Make the total telescope layout large
      layout_config = {
        -- Lowered preview_cutoff to always allow preview
        vertical = { width = 0.99, height = 0.99, preview_height = 0.60, preview_cutoff = 10 },
        horizontal = { width = 0.99, height = 0.99, preview_width = 0.60 },
      },

      -- TODO should this be in telescope.builtin.buffers()?
      sort_lastused = true, -- This will sort by last used
    },
    -- This allows setting config options for each specific picker
    pickers = {
      find_files = {
        -- theme = "ivy", -- Bottom focused window theme
        sort_lastused = true, -- This will sort by last used
      },
      buffers = {
        sort_lastused = true, -- This will sort by last used
      },
      -- oldfiles = {
      --   -- TODO I don't think this works
      --   sort_last_used = true, -- This will sort by last used
      -- },
    },
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown(),
      },
      fzf = {
        fuzzy = false, -- Set to false makes for exact matching
      },
    },
  })
end

return {
  "nvim-telescope/telescope.nvim",
  opts = telescope_opts,
}
