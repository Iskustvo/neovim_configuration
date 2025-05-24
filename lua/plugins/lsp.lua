--- @type LazySpec[]
return {
    -- Lua
    {
        "folke/lazydev.nvim",
        dependencies = {
            "hrsh7th/nvim-cmp",
            opts = function(_, opts)
                --TODO: Try to rewrite "cmp" configuration without callbacks in order to be able to apply
                --      https://github.com/hrsh7th/nvim-cmp/discussions/670
                opts.sources = opts.sources or {}
                table.insert(opts.sources, {
                    name = "lazydev",
                    group_index = 0, -- set group index to 0 to skip loading LuaLS completions
                })
            end,
        },
        ft = "lua",
        opts = {
            lspconfig = false,        -- Don't use any "lspconfig" hacks since I no longer use that plugin.
            library = { "lazy.nvim" } -- Preload "lazy.nvim" type/module completions before seeing it's "require"d.
        },
    },

    -- C++
    {
        "p00f/clangd_extensions.nvim",
        lazy = true,
    },

    -- LSP progress visualization.
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        tag = "legacy",
        config = function()
            require("fidget").setup({
                align = { bottom = false, right = true },
                fmt = { stack_upwards = false },
                text = { spinner = "dots" },
            })
            vim.api.nvim_set_hl(0, "FidgetTitle", { fg = "#569cd6", blend = 0 })
        end,
    },
}
