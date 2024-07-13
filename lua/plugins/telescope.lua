-- Partial plugin specification that lazy.nvim will load at startup.
return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope", -- Lazy load only when Telescope command is used.
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
        },
        config = function()
            local telescope = require("telescope")

            telescope.setup({
                defaults = {
                    scroll_strategy = "limit",
                    prompt_prefix = "",
                    selection_caret = " ",
                    path_display = { "smart" },
                },
            })

            telescope.load_extension("fzf")
            telescope.load_extension("ui-select")
        end,
    },
}
