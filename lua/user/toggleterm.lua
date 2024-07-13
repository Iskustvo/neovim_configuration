require("toggleterm").setup({
    open_mapping = "<C-t>",
    direction = "float",
    float_opts = {
        width = vim.o.columns,
        height = vim.o.lines,
    },
})

-- Use Ctrl+E to go to NORMAL mode inside of terminal window.
vim.api.nvim_set_keymap("t", "<C-e>", "<C-\\><C-n>", { noremap = true })
