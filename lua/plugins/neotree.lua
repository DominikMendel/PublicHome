return {
  "nvim-neo-tree/neo-tree.nvim",
  -- "neo-tree.nvim",
  -- enabled = false,
  opts = function(_, opts)
    return require("astrocore").extend_tbl(opts, {
      filesystem = {
        hijack_netrw_behavior = "disabled",
      },
    })
  end,
}
