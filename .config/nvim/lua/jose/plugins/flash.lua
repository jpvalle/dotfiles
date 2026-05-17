return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    -- Flash configuration
    modes = {
      -- Disable flash for search to fix normal '/' search behavior
      search = {
        enabled = false,
      },
      -- Enable flash for character motions (f, F, t, T)
      char = {
        enabled = true,
        -- Show jump labels for multi-line f/F/t/T motions
        multi_line = true,
        -- Show labels after this many characters
        label = { after = { 0, 0 } },
        -- Keys used for jump labels
        keys = { "f", "j", "d", "k", "s", "l", "a", "h", "g", "u", "r", "i", "e", "o", "w", "q", "p", "b" },
      },
    },
    -- Jump labels appearance
    label = {
      -- Use uppercase for better visibility
      uppercase = true,
      -- Rainbow colors for labels
      rainbow = {
        enabled = true,
        shade = 5,
      },
    },
  },
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "S",
      mode = { "n", "o", "x" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
    {
      "R",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Flash Treesitter Search",
    },
    {
      "<c-s>",
      mode = { "c" },
      function()
        require("flash").toggle()
      end,
      desc = "Toggle Flash Search",
    },
  },
}
