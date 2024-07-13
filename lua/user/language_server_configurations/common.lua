local function enable_lsp_document_highlighting(client, buffer_number)
    if client.server_capabilities.documentHighlightProvider then
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

local M = {}
M.on_attach = function(client, buffer_number)
    require("user.keymaps").set_lsp_keymaps(buffer_number)
    enable_lsp_document_highlighting(client, buffer_number)
end

-- Use extended capabilities provided by cmp-nvim.
M.capabilities = require("cmp_nvim_lsp").default_capabilities()

return M
