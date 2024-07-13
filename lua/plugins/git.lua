vim.opt.diffopt:append({
    "algorithm:histogram", -- Computes more human-readable diffs.
    "indent-heuristic",    -- Additional heuristic to make diff more human-readable.
    "linematch:300"        -- Use Neovim's Linematch option to better represent computed diffs.
})

-- Partial plugin specification that lazy.nvim will load at startup.
return {
    {
        "tpope/vim-fugitive",
        config = function()
            vim.api.nvim_create_autocmd("BufAdd", {
                pattern = { "fugitive:///*" },
                callback = function(arguments) vim.fn.setbufvar(arguments.file, "&buflisted", 0) end,
                desc = "Unlist Fugitive buffers so they won't show in buffer line"
            })
        end
    },

    { "tpope/vim-rhubarb", dependencies = "tpope/vim-fugitive" },

    {
        "lewis6991/gitsigns.nvim",
        config = function()
            vim.api.nvim_create_autocmd("BufAdd", {
                pattern = { "gitsigns:///*" },
                callback = function(arguments) vim.fn.setbufvar(arguments.file, "&buflisted", 0) end,
                desc = "Unlist Gitsigns buffers so they won't show in buffer line"
            })

            require("gitsigns").setup({
                on_attach = require("user.keymaps").set_git_keymaps
            })
        end,
    },
}
