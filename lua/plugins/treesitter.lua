-- List of supported treesitter parsers and corresponding filetypes for which they work.
local parsers_and_filetypes = {
    ["vimdoc"]  = { "help" },  -- Vim :help pages.
    ["vim"]     = { "vim" },   -- Legacy Vimscript files.
    ["lua"]     = { "lua" },   -- Lua scripts.
    ["bash"]    = { "sh" },    -- Bash scripts.
    ["c"]       = { "c" },     -- C source files.
    ["cpp"]     = { "cpp" },   -- C++ source files.
    ["make"]    = { "make" },  -- Make files.
    ["cmake"]   = { "cmake" }, -- CMake files.
    ["json"]    = { "json" },  -- JSON files.

    -- Embedded parsers.
    ["comment"] = {}, -- For "TODO:", "FIXME:", etc. inside comments.
    ["doxygen"] = {}, -- For Doxygen documentation in code comments.
}

local treesitter_parsers = {}
local supported_filetypes = {}
for parser, filetypes in pairs(parsers_and_filetypes) do
    table.insert(treesitter_parsers, parser)
    for _, filetype in ipairs(filetypes) do
        table.insert(supported_filetypes, filetype)
    end
end

-- Partial plugin specification that lazy.nvim will load at startup.
return {
    {
        "nvim-treesitter/nvim-treesitter",
        ft = supported_filetypes, -- Lazy load only when supported filetypes are opened.
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = treesitter_parsers,
                highlight = { enable = true },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = "nvim-treesitter/nvim-treesitter",
        ft = supported_filetypes, -- Lazy load only when supported filetypes are opened.
        config = function()
            require("nvim-treesitter.configs").setup({
                textobjects = {
                    select = {
                        enable = true,    -- Enable selection feature.
                        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim

                        keymaps = {
                            ["ab"] = { query = "@block.outer", desc = "[A] [B]lock" },
                            ["if"] = { query = "@function.inner", desc = "[I]n [F]unction" },
                            ["af"] = { query = "@function.outer", desc = "[A] [F]unction" },
                            ["ic"] = { query = "@class.inner", desc = "[I]n [C]lass" },
                            ["ac"] = { query = "@class.outer", desc = "[A] [C]lass" },
                        },
                    },
                    swap = {
                        enable = true,
                        swap_previous = { ["<C-h>"] = "@parameter.inner", },
                        swap_next = { ["<C-l>"] = "@parameter.inner", },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- Save motions to jump list.
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]c"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            ["]C"] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[c"] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            ["[C"] = "@class.outer",
                        },
                    }
                },
            })
        end,
    }
}
