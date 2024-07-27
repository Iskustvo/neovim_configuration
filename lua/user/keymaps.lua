-------------
-- GENERAL --
-------------

-- Map <Space> as leader key for potential plugin mappings which might use it, though they'll likely be remapped here.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable default <Space> behavior so that Neovim will wait (vim.opt.timeoutlen) for remainder of the keymap sequence.
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { desc = "Disable space key because it's used as map leader key" })

-- Because of Kinesis Advantage keyboard, alternatively use backspace as the map leader key.
-- (Just like there are two Ctrl keys meant for combining with keys on opposite sides of keyboard layout.)
vim.keymap.set({ "n", "v" }, "<BS>", "<Leader>", { remap = true, desc = "Use backspace as alternative map leader key" })

-- For terminals that support modern (fixed) keyboard input (http://www.leonerd.org.uk/hacks/fixterms) that
-- differentiates special characters (like Tab) from Ctrl-modified letters (like Ctrl+i for Tab), it turns out that Tab
-- uses old encoding which was earlier used by both Tab and Ctrl+i. Thus, to continue using <C-i>/<C-o> like
-- before, <C-i> has to be mapped to original behavior that now belongs to <Tab>.
-- To enable modern keyboard input in Simple Terminal, apply patch: https://st.suckless.org/patches/fix_keyboard_input
vim.keymap.set(
    "n",
    "<C-i>",
    "<Tab>",
    { desc = "Map Ctrl+i to behave like Tab. With improved terminal keyboard input, those are no longer the same" }
)

-- Use quick "jk" key sequence to exit INSERT mode.
vim.keymap.set({ "s", "i" }, "jk", "<ESC>", { desc = 'Use "jk" sequence to exit from INSERT mode' })

-- Navigate cmdline history with Ctrl+j, Ctrl+k
vim.keymap.set("c", "<C-j>", "<Down>", { desc = "Navigate command-line history up" })
vim.keymap.set("c", "<C-k>", "<Up>", { desc = "Navigate command-line history down" })

-- Kill arrow mappings everywhere.
vim.keymap.set({ "n", "v", "s", "i", "c", "x", "t" }, "<Left>", "<Nop>", { desc = "Disable left arrow key" })
vim.keymap.set({ "n", "v", "s", "i", "c", "x", "t" }, "<Right>", "<Nop>", { desc = "Disable right arrow key" })
vim.keymap.set({ "n", "v", "s", "i", "c", "x", "t" }, "<Up>", "<Nop>", { desc = "Disable up arrow key" })
vim.keymap.set({ "n", "v", "s", "i", "c", "x", "t" }, "<Down>", "<Nop>", { desc = "Disable down arrow key" })

-- Navigate windows.
-- vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Jump to left window" })
-- vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Jump to window below" })
-- vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Jump to window above" })
-- vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Jump to right window" })

-- Navigate buffers.
vim.keymap.set("n", "L", ":bnext<Enter>", { silent = true, desc = "Jump to next buffer" })
vim.keymap.set("n", "H", ":bprevious<Enter>", { silent = true, desc = "Jump to previous buffer" })

-- Navigate diffs.
vim.keymap.set({ "n", "v" }, "[h", "[czz", { desc = "Jump to previous diff hunk" })
vim.keymap.set({ "n", "v" }, "]h", "]czz", { desc = "Jump to next diff hunk" })

-- Move highlighted text up and down.
vim.keymap.set("v", "J", ":m '>+1<Enter>gv=gv", { silent = true, desc = "Move selected lines up" })
vim.keymap.set("v", "K", ":m '<-2<Enter>gv=gv", { silent = true, desc = "Move selected lines down" })

-- Improve J to join lines without moving the cursor.
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join next line with the current one, without moving cursor" })

-- Position cursor in the middle of the screen after jumping.
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll half page up but keep cursor at the center of the screen" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll half page down but keep cursor at the center of the screen" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Jump to next found item and position it on the center of the screen" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Jump to previous found item and position it on the center of the screen" })
vim.keymap.set("c", "<Enter>", function()
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Enter>", true, false, true), "n")
    if vim.fn.index({ "/", "?" }, vim.fn.getcmdtype()) == 0 then vim.fn.feedkeys("zz", "n") end
end, { desc = "When applying '/' and '?' search requests, position first result on center of the screen" })

----------------
-- COMPLETION --
----------------

local cmp = require("cmp")
local luasnip = require("luasnip")

vim.keymap.set("s", "<Tab>", function() luasnip.jump(1) end, { desc = "Jump to next snippet placeholder" })

vim.keymap.set("i", "<Tab>", function()
    if cmp.visible() then
        cmp.select_next_item()
    elseif luasnip.jumpable(1) then
        luasnip.jump(1)
    else
        -- Calculate how many spaces need to be inserted to mimic insertion of new Tab character.
        local column = vim.fn.col(".") - 1 -- Zero-based indexing.
        local number_of_spaces_per_tab = vim.fn.shiftwidth()
        local number_of_needed_spaces = number_of_spaces_per_tab - column % number_of_spaces_per_tab

        -- Works smarter than vim.fn.feedkeys() because it automatically removes empty lines with just "Tabs".
        vim.api.nvim_put({ string.rep(" ", number_of_needed_spaces) }, "", false, true)
    end
end, { desc = "Select next completion item or jump to next snippet placeholder or simulate tab insertion with spaces" })

vim.keymap.set("c", "<Tab>", function()
    if cmp.visible() then
        cmp.select_next_item()
    else
        cmp.complete()
    end
end, { desc = "Select next completion item or trigger completion" })

vim.keymap.set(
    "s",
    "<S-Tab>",
    function() luasnip.jump(-1) end,
    { desc = "Jump to previous placeholder in snippet expansion history" }
)

vim.keymap.set("i", "<S-Tab>", function()
    if cmp.visible() then
        cmp.select_prev_item()
    else
        luasnip.jump(-1)
    end
end, { desc = "Select previous completion item or jump to previous placeholder in snippet expansion history" })

vim.keymap.set("c", "<S-Tab>", cmp.select_prev_item, { desc = "Select previous completion item" })

vim.keymap.set({ "s", "i" }, "<Enter>", function()
    if cmp.visible() and cmp.get_selected_entry() then
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace })
    else
        vim.fn.feedkeys("\n", "i")
    end
end, { desc = "Confirm selected completion and potentially expand the snippet" })

vim.keymap.set({ "i", "c" }, "<C-e>", cmp.abort, { desc = "[E]xit completion" })
vim.keymap.set(
    { "i", "c" },
    "<C-u>",
    function() cmp.scroll_docs(-5) end,
    { desc = "Scroll completion documentation [U]p" }
)
vim.keymap.set(
    { "i", "c" },
    "<C-d>",
    function() cmp.scroll_docs(5) end,
    { desc = "Scroll completion documentation [D]own" }
)

-------------------
-- QUICKFIX LIST --
-------------------

vim.keymap.set("n", "<Tab>", "<Cmd>cnext<Enter>", { desc = "Jump to next location in quickfix." })
vim.keymap.set("n", "<S-Tab>", "<Cmd>cprevious<Enter>", { desc = "Jump to previous location in quickfix." })
vim.keymap.set("n", "<Del>", "<Cmd>cfirst<Enter>", { desc = "Jump to first location in quickfix." })
vim.keymap.set("n", "<S-Del>", "<Cmd>clast<Enter>", { desc = "Jump to last location in quickfix." })

-------------------
-- MISCELLANEOUS --
-------------------

vim.keymap.set(
    "n",
    "<Leader>h",
    function() print(vim.inspect(vim.treesitter.get_captures_at_cursor(0))) end,
    { desc = "Print highlight group for symbol under cursor" }
)

---------
-- GIT --
---------

-- Computes the default git branch in the given repository.
--
-- @repo_path   Path to git repository or any of its subdirectories.
--
-- @returns     String containing the name of default branch or nil if it failed to compute it.
local function compute_default_branch(repo_path)
    -- Try to determine default branch by searching the branch of the HEAD pointer on "origin" remote.
    local response = vim.system({ "git", "symbolic-ref", "refs/remotes/origin/HEAD", "--short" },
        { cwd = repo_path, text = true }):wait()

    if response.code == 0 then
        return response.stdout:match("%S+")
    end

    -- If command failed (most likely repo isn't connected to any remote), search local bracnhes for "main" or "master".
    response = vim.system({ "git", "branch" }, { cwd = repo_path, text = true }):wait()

    -- If unable to list local branches, just give up.
    if response.code ~= 0 then
        return nil
    end

    -- Prioritize "main" over "master" as the default branch.
    local default_branch = response.stdout:match("%s?(main)%s?")
    if default_branch == nil then
        default_branch = response.stdout:match("%s?(master)%s?")
    end

    return default_branch
end

-- Finds the last common commit of given two git revisions.
--
-- @repo_path    Path to git repository or any of its subdirectories.
-- @revision_1   Any revisition that Git can understand, be it commit SHA, branch name, alias, etc.
-- @revision_2   Any revisition that Git can understand, be it commit SHA, branch name, alias, etc.
--
-- @returns      String containing the SHA of last common commit for given revisions or nil if one can't be computed.
local function find_last_common_commit(repo_path, revision_1, revision_2)
    local response = vim.system({ "git", "merge-base", revision_1, revision_2 }, { cwd = repo_path, text = true }):wait()
    if response.code ~= 0 then
        return nil
    end

    return response.stdout:match("%S+")
end

local M = {}

-- Callback that enables Git keymaps only in specified buffer.
-- This function is intended to be used when "gitsigns" attaches itself to a buffer.
M.set_git_keymaps = function(buffer_number)
    local gitsigns = require("gitsigns")

    -- Navigate hunks.
    vim.keymap.set(
        { "n", "v" },
        "[h",
        function()
            if vim.wo.diff then
                vim.fn.feedkeys("[czz", "n")
            else
                gitsigns.nav_hunk("prev", {}, function() vim.fn.feedkeys("zz", "n") end)
            end
        end,
        { buffer = buffer_number, desc = "Jump to previous diff hunk" }
    )
    vim.keymap.set(
        { "n", "v" },
        "]h",
        function()
            if vim.wo.diff then
                vim.fn.feedkeys("]czz", "n")
            else
                gitsigns.nav_hunk("next", {}, function() vim.fn.feedkeys("zz", "n") end)
            end
        end,
        { buffer = buffer_number, desc = "Jump to next diff hunk" }
    )

    -- TODO: Check if <Leader> key can/should be omitted from following mappings.

    -- Staging.
    vim.keymap.set('n', '<Leader>gsh', gitsigns.stage_hunk, { buffer = buffer_number, desc = "[G]it [S]tage [H]unk" })
    vim.keymap.set(
        'v',
        '<Leader>gs',
        function()
            gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end,
        { buffer = buffer_number, desc = "[G]it [S]tage" })
    vim.keymap.set('n', '<Leader>gsf', gitsigns.stage_buffer, { buffer = buffer_number, desc = "[G]it [S]tage [F]ile" })
    vim.keymap.set('n', '<Leader>gu', gitsigns.undo_stage_hunk,
        { buffer = buffer_number, desc = "[G]it [U]nstage last staged hunk" })

    -- Reseting.
    vim.keymap.set('n', '<Leader>grh', gitsigns.reset_hunk, { buffer = buffer_number, desc = "[G]it [R]eset [H]unk" })
    vim.keymap.set('v',
        '<Leader>gr',
        function()
            gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end,
        { buffer = buffer_number, desc = "[G]it [R]eset" })
    vim.keymap.set('n', '<Leader>grf', gitsigns.reset_buffer, { buffer = buffer_number, desc = "[G]it [R]eset [F]ile" })

    -- Previewing.
    vim.keymap.set(
        'n',
        '<Leader>gp',
        function()
            local available_actions = gitsigns.get_actions()

            -- If cursor is on unstaged hunk, preview it. Otherwise, preview hunk of last commit that changed the line.
            if available_actions["preview_hunk"] ~= nil then
                gitsigns.preview_hunk_inline()
            elseif available_actions["blame_line"] ~= nil then
                gitsigns.blame_line({ full = true })
            else
                print("Nothing to preview")
            end
        end,
        { buffer = buffer_number, desc = "[G]it [P]review" })

    -- Viewing diffs (not available in diffs themselves).
    local buffer_name = vim.fn.bufname(buffer_number)
    if buffer_name:find("^gitsigns:///") == nil and buffer_name:find("^fugitive:///") == nil then
        -- Find directory containing file corresponding to Vim's buffer number.
        local buffer_directory = vim.fn.fnamemodify(buffer_name, ":p:h")

        -- Compute default git branch for git repository in this directory, only once.
        local default_branch = compute_default_branch(buffer_directory)

        vim.keymap.set(
            'n',
            '<Leader>gdi',
            function()
                vim.cmd(":tabnew " .. buffer_name)
                gitsigns.diffthis()
            end,
            { buffer = buffer_number, desc = "[G]it [D]iff [I]ndex" })

        vim.keymap.set(
            'n',
            '<Leader>gdh',
            function()
                vim.cmd(":tabnew " .. buffer_name)
                gitsigns.diffthis("HEAD")
            end,
            { buffer = buffer_number, desc = "[G]it [D]iff [H]ead" })

        vim.keymap.set(
            'n',
            '<Leader>gda',
            function()
                if default_branch == nil then
                    print("Unable to determine default branch")
                    return
                end

                -- Compute last common commit between default branch and current HEAD.
                local last_common_commit = find_last_common_commit(buffer_directory, default_branch, "HEAD")
                if last_common_commit == nil then
                    print("Unable to compute last common commit with between HEAD and " .. default_branch)
                    return
                end

                -- Diff current changes against last common commit between HEAD and default branch.
                vim.cmd(":tabnew " .. buffer_name)
                gitsigns.diffthis(last_common_commit)
            end,
            { buffer = buffer_number, desc = "[G]it [D]iff [A]ll changes after last common commit with default branch" })
    end

    -- https://github.com/lewis6991/gitsigns.nvim/issues/1030
    vim.keymap.set(
        'n',
        '<Enter>',
        function()
            -- Open popup window with commit SHA of blamed line.
            gitsigns.blame_line(
                { full = false },
                function()
                    -- In order to focus opened popup window, blame_line needs to be called again.
                    gitsigns.blame_line({},
                        function()
                            -- Now that popup is focused, extract commit SHA from the start of it.
                            local blamed_commit = vim.fn.getline(1):match("^(%x+)")

                            -- Close the focused popup.
                            vim.cmd(":quit")

                            -- If commit is unavailable (i.e. local changes), reopen the popup window, but without focus.
                            if blamed_commit == nil then
                                gitsigns.blame_line()
                                return
                            end

                            -- Compute parent commit of the blamed one.
                            local blamed_commit_parent = blamed_commit .. "^"
                            local result = vim.system({ "git", "rev-parse", "--short", blamed_commit_parent }):wait()
                            if result.code ~= 0 then
                                print("Ignoring the command since commit " .. blamed_commit_parent .. " doesn't exist!")
                                return
                            end

                            -- Use concrete commit SHA rather than SHA and ^ notation.
                            blamed_commit_parent = result.stdout:match("%S+")

                            -- Create new tab which is viewing current version of the file.
                            vim.cmd(":tabnew %")

                            -- Use new tab to show changes that blamed commit introduced.
                            gitsigns.show(blamed_commit, function() gitsigns.diffthis(blamed_commit_parent) end)
                        end)
                end)
        end,
        { buffer = buffer_number, desc = "[Enter] new tab and show previous changes that modified current line" })

    -- Operator pending mode for git hunks.
    vim.keymap.set(
        { 'o', 'x' },
        "ih",
        ':<C-U>Gitsigns select_hunk<CR>',
        { buffer = buffer_number, desc = "[I]n [H]unk" })


    -- vim.keymap.set(
    --     "n",
    --     "<Leader>gb",
    --     "<Cmd>Git blame<Enter>",
    --     { remap = true, buffer = buffer_number, desc = "Git blame" }
    -- )
end

---------
-- LSP --
---------

-- Callback that enables LSP keymaps only in specified buffer.
-- This function is intended to be used when specific buffers are attached to LSP servers.
M.set_lsp_keymaps = function(buffer_number)
    -- "Go to" keymaps for direct jumping.
    vim.keymap.set(
        "n",
        "gd",
        vim.lsp.buf.definition,
        { buffer = buffer_number, desc = "[G]o to [D]efinition of symbol under cursor." }
    )
    vim.keymap.set(
        "n",
        "gpe",
        vim.diagnostic.goto_prev,
        { buffer = buffer_number, desc = "[G]o to [P]revious [E]rror." }
    )
    vim.keymap.set("n", "gne", vim.diagnostic.goto_next, { buffer = buffer_number, desc = "[G]o to [N]ext [E]rror." })

    -- "List" keymaps for setting and opening quickfix list.
    vim.keymap.set(
        "n",
        "<Leader>ls",
        vim.lsp.buf.document_symbol, -- TODO: https://github.com/simrat39/symbols-outline.nvim
        { buffer = buffer_number, desc = "[L]ist [S]ymbols in current file." }
    )
    vim.keymap.set(
        "n",
        "<Leader>lw", -- TODO Maybe: https://github.com/simrat39/symbols-outline.nvim/issues/159
        vim.lsp.buf.workspace_symbol,
        { buffer = buffer_number, desc = "[L]ist [W]orkspace symbols." }
    )
    vim.keymap.set(
        "n",
        "<Leader>li",
        function() require("trouble").open("lsp_implementations") end,
        { buffer = buffer_number, desc = "[L]ist [I]mplementations of symbol under cursor." }
    )
    vim.keymap.set(
        "n",
        "<Leader>lc",
        vim.lsp.buf.incoming_calls, -- TODO Maybe: https://github.com/folke/trouble.nvim/issues/222
        { buffer = buffer_number, desc = "[L]ist [C]alls of function symbol under cursor." }
    )
    -- vim.keymap.set("n", "<Leader>lo", vim.lsp.buf.outgoing_calls, { buffer = buffer_number }) -- TODO: Not working
    vim.keymap.set(
        "n",
        "<Leader>lr",
        function() require("trouble").open("lsp_references") end,
        { buffer = buffer_number, desc = "[L]ist [R]eferences of symbol under cursor." }
    )
    vim.keymap.set(
        "n",
        "<Leader>le",
        function() require("trouble").open("workspace_diagnostics") end,
        { buffer = buffer_number, desc = "[L]ist [E]rrors in whole project." }
    )

    -- "Show" keymaps for opening non-editable floating windows.
    vim.keymap.set(
        "n",
        "<Leader>sd",
        vim.lsp.buf.hover,
        { buffer = buffer_number, desc = "[S]how [D]eclaration of symbol under cursor." }
    )
    vim.keymap.set(
        "n",
        "<Leader>se",
        vim.diagnostic.open_float,
        { buffer = buffer_number, desc = "[S]how [E]rrors on current line." }
    )

    -- TODO: "Preview" keymaps for editable floating windows. (https://github.com/rmagatti/goto-preview)

    -- "Miscellaneous" keymaps.
    vim.keymap.set("n", "<Leader>f", vim.lsp.buf.format, { buffer = buffer_number, desc = "[F]ormat current file." })
    vim.keymap.set(
        "n",
        "<Leader>r",
        vim.lsp.buf.rename,
        { buffer = buffer_number, desc = "[R]ename symbol under cursor." })
    vim.keymap.set(
        "n",
        "<Leader>a",
        function() vim.lsp.buf.code_action({ apply = true }) end,
        { buffer = buffer_number, desc = "Suggest [C]ode [A]ction on the current line." }
    )
end

return M
