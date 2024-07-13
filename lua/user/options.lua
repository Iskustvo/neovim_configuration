-- :help option-list

vim.opt.mouse = "" -- Disable mouse interactions.

vim.opt.clipboard = { "unnamed", "unnamedplus" } -- Use system clipboard for 'y', 'p', 'c' and 'd' Vim operations.

vim.opt.colorcolumn = "121" -- Set visual indicator for maximum characters per line

vim.opt.ignorecase = true -- Always perform case-insensitive searches.
vim.opt.smartcase = true -- Override case-insensitive searches when pattern contains upper case characters.

vim.opt.pumheight = 10 -- Number of lines in the popup (auto completion) menu.

vim.opt.showmode = false -- Don't output mode name in cmdline area every time the mode changes.

vim.opt.showtabline = 2 -- Always show tabs

vim.opt.swapfile = false -- Don't create swap files.

vim.opt.termguicolors = true -- Allow the use of all GUI colors.

vim.opt.undofile = true -- Enable persistent undo after file is reopened.
vim.opt.undodir = "/tmp/nvim/undo/" -- Write undo files in /tmp (RAM memory).

vim.opt.splitbelow = true -- Open new windows below the current one. It's more convenient for help menu.

vim.opt.updatetime = 300 -- Faster highlight of the word under cursor.

-- Use 4 spaces to replace Tab.
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.cursorline = true -- Highlight the line where cursor is positioned.

vim.opt.number = true -- Write line number on the left side.
vim.opt.numberwidth = 1 -- Use minimal number of columns to represent all line numbers of the file.

vim.opt.wrap = false -- Do not visually wrap the lines when they are longer than the screen.

vim.opt.scrolloff = 5 -- Make sure that 5 lines above and below current line are visible on the screen.
vim.opt.sidescrolloff = 5 -- Make sure that 5 characters before/after current column are visible when side scrolling.

vim.opt.whichwrap = "" -- Disable default over-the-line movement with (back)space in NORMAL and VISUAL modes.

vim.opt.timeoutlen = 300 -- Speedup wait time for hitting the mapped key sequence like `jk` or `q:`.

vim.opt.iskeyword:append("-") -- Make '-' part of the word sequence for 'w', 'e', '*' and other Vim motions.
