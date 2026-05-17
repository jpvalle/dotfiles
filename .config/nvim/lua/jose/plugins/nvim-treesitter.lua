return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()

        local configs = require("nvim-treesitter.configs")
        configs.setup({

            sync_install = false,
            incremental_selection = {
                enable = true,
            },

            highlight = {
                enable = true,
            },
            -- enable indentation
            indent = { enable = true },
            -- enable autotagging (w/ nvim-ts-autotag plugin)
            autotag = {
              enable = true,
            },
            -- ensure these language parsers are installed
            ensure_installed = {
                "lua",
                "luadoc",
                "vim",
                "vimdoc",
                "python",
                "requirements",
                "groovy",
                "bash",
                "dockerfile",
                "markdown",
                "markdown_inline",
                "tmux",
                "toml",
                "git_config",
                "gitcommit",
                "gitignore",
                "json",
                "yaml",
                "sql",
            },
            keymaps = {
              init_selection = "<C-space>",
              node_incremental = "<C-space>",
              scope_incremental = false,
              node_decremental = "<bs>",
            },
        })
    end,
}
