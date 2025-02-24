-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

-- Define a Lua function to create and display the Oil buffer
local function open_persistent_buffer()
  -- Check if the buffer already exists
  local bufnr = vim.fn.bufnr("^Oil$")

  -- If buffer doesn't exist, create it
  if bufnr == -1 then
    bufnr = vim.api.nvim_create_buf(false, true)
    -- Set the buffer name to 'Oil' (optional)
    vim.api.nvim_buf_set_name(bufnr, "Oil")

    -- Set the buffer content (optional)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
      "This is a persistent buffer for Oil.",
      "You can add your content here.",
    })
  end

  -- Open the buffer in a new window (split)
  vim.api.nvim_command("belowright split")
  vim.api.nvim_command("buffer " .. bufnr)
end

local function close_other_windows()
  local current_win = vim.fn.win_getid()

  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    if winid ~= current_win then vim.api.nvim_win_close(winid, true) end
  end
end

-- ("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

local telescope_builtin = require("telescope.builtin")
-- Keymaps
local normal_mappings = {
  -- BUG: This doesn't work
  -- [")q"] = { "]q", desc = "Move focus to the left window" },
  -- ["(q"] = { "[q", desc = "Move focus to the left window" },
  [")q"] = { function() require("qfetter").another() end, desc = "Quicklist forward" },
  ["]q"] = { function() require("qfetter").another() end, desc = "Quicklist forward" },
  ["[q"] = { function() require("qfetter").another({ backwards = true }) end, desc = "Quicklist backwards" },
  ["(q"] = { function() require("qfetter").another({ backwards = true }) end, desc = "Quicklist backwards" },

  -- Remove some Astro keybinds
  ["<Leader>h"] = false,
  ["<Leader>w"] = false,

  ["<Esc>"] = { "<cmd>nohlsearch<CR>" },
  ["<Leader>e"] = { vim.diagnostic.open_float, desc = "Show diagnostic [E]rror messages" },
  ["<Leader>q"] = { vim.diagnostic.setloclist, desc = "Open diagnostic [Q]uickfix list" },
  ["<Leader>wh"] = { "<C-w><C-h>", desc = "Move focus to the left window" },
  ["<Leader>wl"] = { "<C-w><C-l>", desc = "Move focus to the right window" },
  ["<Leader>wj"] = { "<C-w><C-j>", desc = "Move focus to the lower window" },
  ["<Leader>wk"] = { "<C-w><C-k>", desc = "Move focus to the upper window" },
  -- Window splits
  ["<Leader>w-"] = { "<Cmd>split<Cr>", desc = "Split window horizontally" },
  ["<Leader>w/"] = { "<Cmd>vsplit<Cr>", desc = "Split window vertically" },
  -- Temp buffer
  ["<Leader>x"] = { "<Cmd>enew<Cr>", desc = "Open new buffer" },

  ["<C-x>1"] = { function() close_other_windows() end, desc = "Close other windows" },
  ["<C-x>0"] = { function() vim.api.nvim_win_close(vim.fn.win_getid(), true) end, desc = "Close current window" },

  -- Buffers
  ["<Leader>bk"] = { "<Cmd>bd<Cr>", desc = "[B]uffer [K]ill" },
  ["<Leader>bn"] = { "<Cmd>bn<Cr>", desc = "[B]uffer [N]ext" },
  ["<Leader>bp"] = { "<Cmd>bp<Cr>", desc = "[B]uffer [P]revious" },

  -- Recenter on jumps
  ["<C-d>"] = "<C-d>zz",
  ["<C-u>"] = "<C-u>zz",

  -- Amplify H and L
  ["H"] = "0^",
  ["L"] = "$",

  -- Don't move the cursor when combining lines
  ["J"] = "mzJ`z",

  -- Get filename
  -- ("n", "<Leader>fy", copy_git_relative)

  -- Delete current file
  ["<Leader>fD"] = {
    function()
      local confirm = vim.fn.confirm("Delete buffer and file?", "&Yes\n&No", 2)

      if confirm == 1 then
        os.remove(vim.fn.expand("%"))
        vim.api.nvim_buf_delete(0, { force = true })
      end
    end,
    desc = "Delete current file",
  },

  -- Open file editor
  -- Open Neotree
  ["<Leader>op"] = function() vim.cmd("Neotree toggle") end,
  -- ["<leader>."] = "<CMD>Oil --float<CR>",
  ["<leader>."] = "<CMD>Oil<CR>",
  -- BUG: This doesn't work
  -- ["<leader>."] = "<CMD>lua open_persistent_buffer()<CR>",

  -- Telescope:
  ["<Leader>sh"] = { telescope_builtin.help_tags, desc = "[S]earch [H]elp" },
  ["<Leader>sk"] = { telescope_builtin.keymaps, desc = "[S]earch [K]eymaps" },
  -- ["<Leader>sf"] = telescope_builtin.find_files, { desc = "[S]earch [F]iles"},
  -- ["<Leader>sf"] = function()
  -- 	telescope_builtin.find_files({ follow = true }),
  -- end, { desc = "[S]earch [F]iles" }),
  ["<Leader>ss"] = { telescope_builtin.builtin, desc = "[S]earch [S]elect Telescope" },
  ["<Leader>sw"] = { telescope_builtin.grep_string, desc = "[S]earch current [W]ord" },
  ["<Leader>sg"] = { telescope_builtin.live_grep, desc = "[S]earch by [G]rep" },
  ["<Leader>sd"] = { telescope_builtin.diagnostics, desc = "[S]earch [D]iagnostics" },
  ["<Leader>sr"] = { telescope_builtin.resume, desc = "[S]earch [R]esume" },
  ["<Leader>s."] = { telescope_builtin.oldfiles, desc = '[S]earch Recent Files ("." for repeat)' },
  ["<Leader><leader>"] = { telescope_builtin.buffers, desc = "[ ] Find existing buffers" },

  -- My keybinds
  -- LSP keybind
  ["<Leader>cr"] = { vim.lsp.buf.rename, desc = "[C]ode [R]ename" },
  -- Telescope
  ["<Leader>hf"] = { telescope_builtin.help_tags, desc = "[H]elp [F]unctions" },
  ["<Leader>hk"] = { telescope_builtin.keymaps, desc = "[H]elp [K]eybinds" },
  ["<Leader>pf"] = {
    function() telescope_builtin.find_files({ follow = true, hidden = true }) end,
    -- TODO: What does the cwd even do?
    -- function() telescope_builtin.find_files({ follow = true, hidden = true, cwd = require("oil").get_current_dir() }) end,
    desc = "[P]roject find [F]iles",
  },
  -- ["<Leader>ss"] = telescope_builtin.builtin, { desc = "[S]ebrch [S]elect Telescope" },
  ["<Leader>sb"] = { telescope_builtin.current_buffer_fuzzy_find, desc = "[S]earch current [B]uffer" },
  -- -- TODO: This doesn't search symlink
  -- ["<Leader>ps"] = telescope_builtin.live_grep, { desc = "[P]roject [S]earch grep" },
  -- ["<Leader>sp"] = telescope_builtin.live_grep, { desc = "[S]earch [P]roject" },
  ["<Leader>ps"] = {
    function() telescope_builtin.live_grep({ follow = true }) end,
    desc = "[P]roject [S]earch grep",
  },
  ["<Leader>sp"] = {
    function() telescope_builtin.live_grep({ follow = true }) end,
    desc = "[P]roject [S]earch grep",
  },
  -- -- vim.keymap.set("n", "<Leader>sd", telescope_builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
  -- -- vim.keymap.set("n", "<Leader>sr", telescope_builtin.resume, { desc = "[S]earch [R]esume" })
  ["<Leader>bb"] = { telescope_builtin.buffers, desc = "[B]uffer search [B]uffers" },
  --
  -- -- Slightly advanced example of overriding default behavior and theme
  ["<Leader>/"] = {
    function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      telescope_builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end,
    desc = "[/] Fuzzily search in current buffer",
  },
  --
  -- -- It's also possible to pass additional configuration options.
  -- --  See `:help telescope.telescope_builtin.live_grep()` for information about particular keys
  ["<Leader>s/"] = {
    function()
      telescope_builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      })
    end,
    desc = "[S]earch [/] in Open Files",
  },

  -- Shortcut for searching your Neovim configuration files
  ["<Leader>sn"] = {
    function() telescope_builtin.find_files({ cwd = vim.fn.stdpath("config") }) end,
    desc = "[S]earch [N]eovim files",
  },

}

-- "x"
local visual_mappings = {
  -- BUG: This doesn't work
  -- Shift J/K move blocks
  -- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
  -- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
  -- ["J"] = "<Cmd>m '>+1<CR>gv=gv",
  -- ["K"] = "<Cmd>m '<-2<CR>gv=gv",

  -- Don't break visual mode in shifting text
  [">"] = ">gv",
  ["<"] = "<gv",

  -- Don't override the register when pasting
  ["p"] = [["_dP]],
}

local insert_mappings = {}

local pending_mappings = {}

local command_mappings = {}

local command_insert_mappings = {}

local normal_visual_pending_mappings = {}

local normal_visual_mappings = {}

local insert_select_mappings = {}

local visual_select_mappings = {}

local normal_insert_select_mappings = {}

local all_modes_mappings = {
  ["<A-x>"] = { telescope_builtin.commands, desc = "Execute command" },
}

local mappings_table = {
  n = normal_mappings,
  x = visual_mappings,
  i = insert_mappings,
  o = pending_mappings,
  c = command_mappings,
  ["!"] = command_insert_mappings,
  s = {},
  v = {},
}

for key, value in pairs(all_modes_mappings) do
  mappings_table.n[key] = value
  mappings_table.x[key] = value
  mappings_table.o[key] = value
  -- BUG: This doesn't work
  -- mappings_table["!"][key] = value
end

for key, value in pairs(normal_visual_pending_mappings) do
  mappings_table.n[key] = value
  mappings_table.x[key] = value
  mappings_table.o[key] = value
end

for key, value in pairs(normal_visual_mappings) do
  ---@diagnostic disable-next-line: assign-type-mismatch
  mappings_table.n[key] = value
  ---@diagnostic disable-next-line: assign-type-mismatch
  mappings_table.x[key] = value
end

for key, value in pairs(insert_select_mappings) do
  mappings_table.i[key] = value
  mappings_table.s[key] = value
end

for key, value in pairs(visual_select_mappings) do
  mappings_table.x[key] = value
  mappings_table.s[key] = value
end

for key, value in pairs(normal_insert_select_mappings) do
  mappings_table.n[key] = value
  mappings_table.i[key] = value
  mappings_table.s[key] = value
end

local opts_table = {
  -- Configure core features of AstroNvim
  features = {
    large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
    autopairs = true, -- enable autopairs at start
    cmp = true, -- enable completion at start
    diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
    highlighturl = true, -- highlight URLs at start
    notifications = true, -- enable notifications at start
  },
  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },
  on_keys = {
    auto_hlsearch = false,
  },
  -- vim options can be configured here
  options = {
    opt = { -- vim.opt.<key>
      -- relativenumber = true, -- sets vim.opt.relativenumber
      -- number = true, -- sets vim.opt.number
      spell = false, -- sets vim.opt.spell
      -- signcolumn = "yes", -- sets vim.opt.signcolumn to yes
      wrap = false, -- sets vim.opt.wrap

      -- Personal:
      -- [[ Setting options ]]
      -- See `:help
      -- NOTE: You can change these options as you wish!
      --  For more options, you can see `:help option-list`

      -- Remove tabline from AstroNvim
      showtabline = 0,

      -- Make line numbers default
      number = true,
      -- You can also add relative line numbers, to help with jumping.
      --  Experiment for yourself to see if you like it!
      relativenumber = true,

      -- Enable mouse mode, can be useful for resizing splits for example!
      mouse = "a",

      -- Don't show the mode, since it's already in the status line
      showmode = false,

      -- Sync clipboard between OS and Neovim.
      --  Remove this option if you want your OS clipboard to remain independent.
      --  See `:help 'clipboard'`
      clipboard = "unnamedplus",

      -- Enable break indent
      breakindent = true,

      -- Save undo history
      undofile = true,

      -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
      ignorecase = true,
      smartcase = true,

      -- Keep signcolumn on by default
      -- signcolumn = "yes"
      signcolumn = "auto",

      -- Decrease update time
      updatetime = 250,

      -- Decrease mapped sequence wait time
      -- Displays which-key popup sooner
      -- timeoutlen = 300
      -- timeoutlen = 50, -- BUG This breaks surround for some reason

      -- Configure how new splits should be opened
      splitright = true,
      splitbelow = true,

      -- Sets how neovim will display certain whitespace characters in the editor.
      --  See `:help 'list'`
      --  and `:help 'listchars'`
      list = true,
      listchars = { tab = "» ", trail = "·", nbsp = "␣" },

      -- Preview substitutions live, as you type!
      -- inccommand = "split",
      inccommand = "nosplit",

      -- Show which line your cursor is on
      cursorline = true,

      -- Minimal number of screen lines to keep above and below the cursor.
      scrolloff = 12,

      -- Set highlight on search, but clear on pressing <Esc> in normal mode
      hlsearch = true,

      incsearch = true,

      -- What a tab character visually looksl ike
      tabstop = 4,
      shiftwidth = 4,
      -- Converts tabs to spaces
      expandtab = true,

      -- GUI
      termguicolors = true,
    },
    g = { -- vim.g.<key>
      -- configure global vim variables (vim.g)
      -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
      -- This can be found in the `lua/lazy_setup.lua` file
      have_nerd_font = true,
      -- For package "FraserLee/ScratchPad"
      scratchpad_autostart = 0,
    },
  },
  -- Mappings can be configured through AstroCore as well.
  -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
  -- mappings = {
  --   -- first key is the mode
  --   n = {
  --     -- second key is the lefthand side of the map
  --
  --     -- navigate buffer tabs
  --     ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
  --     ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
  --
  --     -- mappings seen under group name "Buffer"
  --     ["<Leader>bd"] = {
  --       function()
  --         require("astroui.status.heirline").buffer_picker(
  --           function(bufnr) require("astrocore.buffer").close(bufnr) end
  --         )
  --       end,
  --       desc = "Close buffer from tabline",
  --     },
  --
  --     -- tables with just a `desc` key will be registered with which-key if it's installed
  --     -- this is useful for naming menus
  --     -- ["<Leader>b"] = { desc = "Buffers" },
  --
  --     -- setting a mapping to false will disable it
  --     -- ["<C-S>"] = false,
  --
  --   },
  -- },
}

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@param opts AstroCoreOpts
  opts = function(_, opts)
    ---@diagnostic disable-next-line: inject-field
    -- NOTE: Use this to delete all of Astro keybinds
    -- opts.mappings = mappings_table
    -- Or use this to keep Astro's keybinds
    opts.mappings = require("astrocore").extend_tbl(opts.mappings, mappings_table)
    ---@diagnostic disable-next-line: undefined-field
    opts.autocmds.autoview = nil
    ---@diagnostic disable-next-line: undefined-field
    opts.autocmds.q_close_windows = nil
    return require("astrocore").extend_tbl(opts, opts_table)
  end,
}
