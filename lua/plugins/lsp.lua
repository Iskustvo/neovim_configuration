-- Generates a superset of nvim-lspconfig configuration for requested server by using common
-- (user/language_server_configurations/common.lua) configuration and overriding parts of it with custom
-- (user/language_server_configurations/[server_name].lua) configuration, if it exists.
-- It returns a table with 2 fields:
-- * 'lspconfig'  - Configuration that should be passed to nvim-lspconfig.
-- * 'extensions' - Additional configuration that is not standard and has meanings only for some servers (e.g. clangd).
local function generate_server_configuration(server_name)
    local server_configuration = {}
    server_configuration.lspconfig = require("user.language_server_configurations.common")

    local custom_server_configuration_path = "user.language_server_configurations." .. server_name
    local has_custom_configuration, custom_server_configuration = pcall(require, custom_server_configuration_path)
    if has_custom_configuration then
        server_configuration = vim.tbl_deep_extend("force", server_configuration, custom_server_configuration)
    end

    return server_configuration
end

-- Partial plugin specification that lazy.nvim will load at startup.
return {
    -- LSP configurations.
    {
        "neovim/nvim-lspconfig",
        lazy = false,                      -- Plugin is already working lazily and that complicates things.
        dependencies = {
            "folke/neodev.nvim",           -- Specific LSP extensions for Neovim development.
            "p00f/clangd_extensions.nvim", -- Clangd extensions for LSP.
        },
        config = function()
            -- Lua
            require("neodev").setup() -- For whatever reason, Neodev is ALWAYS working only when it's set up right here.
            require("lspconfig")["lua_ls"].setup(generate_server_configuration("lua_ls").lspconfig)

            -- C++
            require("lspconfig")["clangd"].setup(generate_server_configuration("clangd").lspconfig)
        end,
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
