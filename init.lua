require("user.options")

-- Automatically install Lazy if needed.
local lazy_install_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if vim.fn.isdirectory(lazy_install_path) == 0 then
    print("Downloading and installing Lazy to: " .. lazy_install_path)
    vim.fn.system("git clone --filter=blob:none https://github.com/folke/lazy.nvim.git " .. lazy_install_path)
end

-- Add Lazy's path in Run Time Path so that it can be loaded when required.
vim.opt.rtp:prepend(lazy_install_path)

-- FIXME: Copied from keymaps.lua, remove when keymaps are independent and can be required at top.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Describe needed plugin dependencies for Lazy to manage.
require("lazy").setup({
    { import = "plugins" },

    { "folke/which-key.nvim", event = "VeryLazy", config = true },

    -- Comments.
    { "numToStr/Comment.nvim",    config = true },

    -- File explorer.
    { "kyazdani42/nvim-tree.lua", dependencies = "kyazdani42/nvim-web-devicons" },

    -- Tabs.
    { "akinsho/bufferline.nvim",  dependencies = "kyazdani42/nvim-web-devicons" },
    -- use "nvim-lualine/lualine.nvim"

    -- Persisting toggling terminals.
    { "akinsho/toggleterm.nvim" },

    { "folke/trouble.nvim",       dependencies = "kyazdani42/nvim-web-devicons" },
    -- "rmagatti/goto-preview", -- TODO: Figure if needed after Trouble.nvim

    { "rcarriga/nvim-dap-ui",     dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },

    -- TODO: Check out
    -- use ghostbuster91/nvim-next
    -- use kylechui/nvim-surround
    -- use andymass/vim-matchup
    -- use ziontee113/syntax-tree-surfer or drybalka/tree-climber.nvim
    -- use "ahmedkhalf/project.nvim"
    -- use "lukas-reineke/indent-blankline.nvim"
    -- use "goolord/alpha-nvim"
    -- use "folke/which-key.nvim"
    -- use "gbprod/substitute.nvim" or "tommcdo/vim-exchange"
}, {
    defaults = {
        lazy = false,
    },
})

require("user.diagnostics")
require("user.nvim-tree")
require("user.bufferline")
require("user.toggleterm")
require("user.debug")

-- require "user.lualine"
-- require "user.project"
-- require "user.indentline"
-- require "user.alpha"
-- require "user.whichkey"
-- require "user.autocommands"

-- Keep it at the bottom untill everything is configured and Tab, Enter and Shift+Tab are working correctly.
require("user.keymaps")
