vim.diagnostic.config({
    underline = true,
    virtual_text = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
        }
    },
    float = {
        header = "",
        source = true,
        border = "rounded",
    },
    update_in_insert = false,
    severity_sort = true,
})
