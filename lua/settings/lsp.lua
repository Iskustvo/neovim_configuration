--- Enables automatic highlighting of cursor-selected symbol throughout the document.
---
--- Note that this feature will work only for external servers which supports document highlighting.
---
--- @param client vim.lsp.Client Neovim's LSP client that is managing communication with the server.
--- @param buffer_number integer Buffer number of a file for which symbol highlighting will be enabled.
---
local function enable_lsp_document_highlighting(client, buffer_number)
    if (client.server_capabilities.documentHighlightProvider) then
        vim.api.nvim_create_autocmd("CursorHold", {
            desc = "Highlight symbol under cursor and its meaningful visible references",
            buffer = buffer_number,
            callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd("CursorMoved", {
            desc = "Remove symbol highlight",
            buffer = buffer_number,
            callback = vim.lsp.buf.clear_references,
        })
    end
end

--- Table containing Neovim's capabilities that language servers need to know about.
--- This variable is used to cache the table, so that it's computed only on first request and later just returned.
---
--- @type lsp.ClientCapabilities?
local neovim_capabilities

local common_settings = {
    --- Function returning Neovim's full list of capabilities.
    ---
    --- @return lsp.ClientCapabilities
    get_capabilities = function()
        if neovim_capabilities == nil then
            neovim_capabilities = vim.tbl_deep_extend(
                "force",
                vim.lsp.protocol.make_client_capabilities(),    -- Default Neovim capabilities.
                require("cmp_nvim_lsp").default_capabilities()) -- Additional nvim-cmp capabilities.
        end

        return neovim_capabilities
    end,

    --- Callback that performs common tasks when buffer is attached to a language server.
    ---
    --- @param client vim.lsp.Client Neovim's LSP client that is managing communication with the server.
    --- @param buffer_number integer Buffer number of a file that is being attached to a language server.
    ---
    on_attach = function(client, buffer_number)
        require("settings.keymaps").set_lsp_keymaps(buffer_number)
        enable_lsp_document_highlighting(client, buffer_number)
    end,
}

-- Set common configuration for all available language servers.
-- This has lowest priority, so any language server can override any part of it.
vim.lsp.config("*", { on_attach = common_settings.on_attach })

-- Notify Neovim to enable configured language servers in order to start attaching buffers to them.
-- Make sure to use "lua_ls" name for "lua-language-server", because lazydev.nvim doesn't work without it.
-- https://github.com/folke/lazydev.nvim/discussions/28
vim.lsp.enable({ "lua_ls", "clangd" })

local M = {}
M.common_settings = common_settings
return M
