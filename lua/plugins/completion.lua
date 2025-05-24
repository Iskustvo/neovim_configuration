local completion_type_icons = {
    Text = "󰉿 ",
    Method = "m ",
    Function = "󰊕 ",
    Constructor = " ",
    Field = " ",
    Variable = "󰆧 ",
    Class = "󰌗 ",
    Interface = " ",
    Module = " ",
    Property = " ",
    Unit = " ",
    Value = "󰎠 ",
    Enum = " ",
    Keyword = "󰌋 ",
    Snippet = " ",
    Color = "󰏘 ",
    File = "󰈙 ",
    Reference = " ",
    Folder = "󰉋 ",
    EnumMember = " ",
    Constant = "󰇽 ",
    Struct = " ",
    Event = " ",
    Operator = "󰆕 ",
    TypeParameter = "󰊄 ",
}

-- Partial plugin specification that lazy.nvim will load at startup.
return {
    -- Completion engine.
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "kyazdani42/nvim-web-devicons",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "Iskustvo/cmp-zsh",                    -- Original plugin seems unmaintained -> Fork and hack completion cache path.
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help", -- TODO: Consider using https://github.com/ray-x/lsp_signature.nvim
        },
        config = function()
            local cmp = require("cmp")
            local default_cmp_configuration = require("cmp.config.default")()

            -- Set up global configuration.
            cmp.setup({
                enabled = default_cmp_configuration.enabled,
                performance = default_cmp_configuration.performance,
                preselect = default_cmp_configuration.preselect,
                completion = default_cmp_configuration.completion,
                confirmation = default_cmp_configuration.confirmation,
                matching = default_cmp_configuration.matching,
                sorting = default_cmp_configuration.sorting,

                mapping = {},

                -- Use LuaSnip as NECESSARY snippet engine for LSP expansions.
                snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },

                -- Source engines used to populate completion.
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "path" },
                    { name = "buffer" },
                }),

                formatting = {
                    expandable_indicator = true,
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        -- Define "menu" field based on the source.
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            path = "[Path]",
                            buffer = "[Buffer]",
                            cmdline = "[Command]",
                            zsh = "[Zsh]",
                        })[entry.source.name]

                        -- Use developer icons for files in completion menu.
                        if entry.source.name == "path" then
                            local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item()
                                .label)
                            if icon then
                                vim_item.kind = icon .. " "
                                vim_item.kind_hl_group = hl_group
                                return vim_item
                            end
                        end

                        -- Use hardcoded icons for the rest.
                        vim_item.kind = completion_type_icons[vim_item.kind]

                        return vim_item
                    end,
                },

                -- When completion menu is above edited line, start selecting from the bottom.
                view = { entries = { name = "custom", selection_order = "near_cursor" } },

                -- Add borders for the documentation/preview window.
                window = { documentation = cmp.config.window.bordered() },
            })

            -- For seraches, override global configuration to suggest only buffer completions.
            cmp.setup.cmdline({ "/", "?" }, { sources = { { name = "buffer" } } })

            -- For command line, override global configuration to suggest only Vim and Zsh command completions.
            cmp.setup.cmdline(":", {
                sources = cmp.config.sources(
                    { { name = "path" } },

                    -- TODO: 'entry_filter' disables zsh completions for non-shell commands, but is not gentle with CPU.
                    --       It also disables zsh completions with any range specification before "!".
                    { { name = "zsh", entry_filter = function() return string.sub(vim.fn.getcmdline(), 1, 1) == "!" end } },
                    { { name = "cmdline" } }
                ),
            })
        end,
    },

    -- Auto pairing.
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({ map_cr = false })
            require("cmp").event:on("confirm_done", require('nvim-autopairs.completion.cmp').on_confirm_done())
        end,
    },
}
