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

local common_settings = {
    --- Table containing Neovim's capabilities that language servers need to know about.
    ---
    --- @type lsp.ClientCapabilities
    ---
    capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),    -- Default Neovim capabilities.
        require("cmp_nvim_lsp").default_capabilities()) -- Additional nvim-cmp capabilities.
    ,

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

local M = {}
M.common_settings = common_settings
return M
