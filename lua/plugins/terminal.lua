--- @type ToggleTermConfig
--- @diagnostic disable-next-line
local default_terminal_settings = {
    --- By default, spawn horizontal terminals with height of 20 lines and keep them consistent.
    size = 20,
    direction = "horizontal",
    persist_size = true,
    responsiveness = { horizontal_breakpoint = 0 },

    --- Use same shell and environment variables as Neovim does.
    shell = vim.o.shell,
    clear_env = false,

    --- Start terminals in insert mode and save/restore their current mode after every toggle.
    start_in_insert = true,
    persist_mode = true,

    --- Only hide line numbers in terminal buffers and don't do any other visual modifications.
    hide_numbers = true,
    shade_terminals = false,
    shade_filetypes = {},
    highlights = {},

    --- Don't sync terminal's current directory, follow the output and close after predefined command is done.
    auto_scroll = true,
    autochdir = false,
    close_on_exit = true,
}

--- Spawns persistent terminal (i.e. terminal which will be respawned after user exits it naturally) in the background.
---
--- @param terminal_settings TermCreateArgs Terminal settings used for creating persistent terminal.
---
local function spawn_persistent_terminal(terminal_settings)
    local Terminal = require("toggleterm.terminal").Terminal

    --- Note: "close_on_exit" and "on_exit" don't play nice together. Right now, "on_exit" has to handle everything.
    terminal_settings.close_on_exit = false
    terminal_settings.on_exit = function(terminal)
        --- Properly close/clean up exiting instance of this terminal.
        terminal:close()
        vim.api.nvim_buf_delete(terminal.bufnr, { force = true })

        --- Spawn new instance of the same terminal in the background.
        Terminal:new(terminal_settings):spawn()
    end

    --- Spawn first instance of this terminal in the background.
    Terminal:new(terminal_settings):spawn()
end

--- @type LazySpec[]
return {
    {
        'akinsho/toggleterm.nvim',
        lazy = true,
        config = function()
            require("toggleterm").setup(default_terminal_settings)

            --- Variable for saving original command line height, since it has to be 0 for fullscreen terminals to work.
            local original_cmdheight

            --- @type TermCreateArgs
            local main_terminal_settings = {
                display_name = "default",
                count = 1,
                direction = "float",
                float_opts = {
                    border = "none",
                    width  = vim.o.columns,
                    height = vim.o.lines,
                },
                on_open = function()
                    original_cmdheight = vim.o.cmdheight
                    vim.o.cmdheight = 0
                end,
                on_close = function()
                    vim.o.cmdheight = original_cmdheight
                end,
            }

            --- Default fullscreen terminal used for common tasks.
            spawn_persistent_terminal(main_terminal_settings)
        end
    }
}
