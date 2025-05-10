-- Partial plugin specification that lazy.nvim will load at startup.
return {
    -- Visual Studio Code colorscheme writen in Lua.
    {
        "Mofiqul/vscode.nvim", -- Use with "colorscheme vscode"
        lazy = false,
        priority = 1000,
        config = function()
            local vscode = require("vscode")

            -- TODO: Check https://github.com/Mofiqul/vscode.nvim/pull/236.
            vscode.setup({
                color_overrides = {
                    vscCursorDarkDark = '#222222'
                }
            })

            vscode.load("dark")
        end,
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
