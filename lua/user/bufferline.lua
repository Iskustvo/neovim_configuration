require("bufferline").setup({
    options = {
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "center",
                separator = false,
            },
        },

        show_close_icon = false,
        show_buffer_close_icons = false,

        indicator = { style = "none" },

        -- TODO: Try to mimic powerline with ''.
        separator_style = { "", "" },
    },

    highlights = {
        fill = {
            fg = { attribute = "fg", highlight = "Normal" },
            bg = { attribute = "bg", highlight = "StatusLineNC" },
        },

        background = {
            fg = { attribute = "fg", highlight = "Normal" },
            bg = { attribute = "bg", highlight = "StatusLine" },
        },

        buffer_visible = {
            fg = { attribute = "fg", highlight = "Normal" },
            bg = { attribute = "bg", highlight = "Normal" },
        },

        buffer_selected = {
            fg = { attribute = "fg", highlight = "Normal" },
            bg = { attribute = "bg", highlight = "Normal" },
        },

        -- TODO: Check out why anything aside from `separator` is not working:
        --       https://github.com/akinsho/bufferline.nvim/issues/608
        -- separator =
        -- {
        --     fg = { attribute = "bg", highlight = "Normal" },
        --     bg = { attribute = "bg", highlight = "StatusLine" },
        -- },
        --
        -- separator_selected =
        -- {
        --     fg = { attribute = "fg", highlight = "Special" },
        --     bg = { attribute = "bg", highlight = "Normal" },
        -- },
        --
        -- separator_visible =
        -- {
        --     fg = { attribute = "fg", highlight = "Normal" },
        --     bg = { attribute = "bg", highlight = "StatusLineNC" },
        -- },
    },
})
