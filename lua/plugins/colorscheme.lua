-- Partial plugin specification that lazy.nvim will load at startup.
return {
    -- Visual Studio Code colorscheme writen in Lua.
    {
        "Mofiqul/vscode.nvim", -- Use with "colorscheme vscode"
        lazy = false,
        priority = 1000,
        config = function() require("vscode").load("dark") end,
    },

    -- Visual Studio Code colorscheme writen in Vimscript, used for comparison.
    {
        "tomasiser/vim-code-dark", -- Use with "colorscheme codedark"
        lazy = true,
    },

    -- Colorscheme used as a feature-complete reference for comparison.
    {
        "folke/tokyonight.nvim", -- Use with "colorscheme tokyonight"
        lazy = true,
    },
}
