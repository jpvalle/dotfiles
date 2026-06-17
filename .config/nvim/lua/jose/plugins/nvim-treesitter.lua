return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "windwp/nvim-ts-autotag" },
    config = function()
        require("nvim-treesitter").setup()
        require("nvim-treesitter.configs").setup({
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
                "jinja",
            }
        })
        local langs = {
            "lua",
            "python",
            "bash",
            "json",
            "yaml",
            "markdown",
        }

        vim.api.nvim_create_autocmd("FileType", {
            pattern = langs,
            callback = function()
                vim.treesitter.start()
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        })

        require("nvim-ts-autotag").setup()
    end,
}
