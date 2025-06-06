--- Partial plugin specification that lazy.nvim will load at startup.
--- @type LazySpec[]
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
                    mappings = require("settings.keymaps").create_default_telescope_mappings(),

                    scroll_strategy = "limit",
                    prompt_prefix = "",
                    selection_caret = " ",
                },
            })

            telescope.load_extension("fzf")
            telescope.load_extension("ui-select")
        end,
    },
}
