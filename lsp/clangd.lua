-- TODO: Figure out pure Lua way to make it work cross platform.
local total_number_of_system_threads = string.gsub(vim.fn.system("nproc"), "%s*", "")

--- Chooses the current or parent directory containing "compile_commands.json" file.
---
--- To better support nested projects, Neovim's current directory is chosen if:
--- * It is eligible to be root directory (i.e. it contains "compile_commands.json").
--- * It (in)directly contains the target file, provided by buffer number.
--- Otherwise, typical parent search is performed to find the root directory.
---
--- @param buffer_number integer Buffer number of a file for which root directory will be searched.
---
--- @return string? # Path to chosen root directory or nil if it could not be found.
---
local function choose_clangd_root(buffer_number)
    local root_marker = "compile_commands.json"
    local current_directory = vim.fs.abspath(vim.fn.getcwd())
    local target_file = vim.fs.normalize(vim.fs.abspath(vim.fn.bufname(buffer_number)))

    -- Use current directory as project root if it's eligible and contains the target file.
    if target_file:find(current_directory, 1, true) and io.open(vim.fs.joinpath(current_directory, root_marker)) then
        return current_directory
    end

    return vim.fs.root(target_file, root_marker)
end

--- @type vim.lsp.Config
return {
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
    root_dir = function(buffer_number, start_clangd)
        local root_directory = choose_clangd_root(buffer_number)

        -- If there's no appropriate root directory, start/reuse preconfigured clangd in a single-file mode.
        if not root_directory then
            start_clangd()
            return
        end

        -- Otherwise, start/reuse clangd instance in chosen root directory and make it use compile_commands from there.
        local new_configuration = {
            name      = vim.lsp.config["clangd"].name,
            root_dir  = root_directory,
            cmd       = {}, -- Make sure not to reference (and modify) global configuration.
            on_attach = vim.lsp.config["clangd"].on_attach,
        }

        -- Deep-copy default invocation command and add "--compile-commands-dir=" to chosen root directory.
        for _, command_argument in ipairs(vim.lsp.config["clangd"].cmd) do --- @diagnostic disable-line
            table.insert(new_configuration.cmd, command_argument)
        end
        table.insert(new_configuration.cmd, "--compile-commands-dir=" .. root_directory)

        vim.lsp.start(new_configuration)
    end,
    cmd = {
        "clangd",
        "--all-scopes-completion=true",          -- Suggest completion from other namespaces.
        "--background-index=true",               -- Index project in background and store data in .cache.
        "--background-index-priority=normal",    -- Build index with same priority as interactive work.
        "--clang-tidy=true",                     -- Report clang-tidy diagnostics through LSP.
        "--completion-style=detailed",           -- Do not bundle multiple overloads in 1 completion.
        "--fallback-style=mozilla",              -- Least useless clang-format style for fallback.
        "--header-insertion=iwyu",               -- Also include needed headers while doing completion.
        "--header-insertion-decorators=true",    -- Visualise header inclusion in completion.
        -- "--enable-config=true",                  -- TODO: Define default configuration and test it.
        "-j=" .. total_number_of_system_threads, -- Use all system threads for computation.
        "--malloc-trim=true",                    -- Periodically release unneeded memory.
        "--pch-storage=memory",                  -- Store precompiled headers in memory.
        -- "--log=<value>",                         -- TODO: Investigate error/info/verbose options.
        "--pretty=false",                        -- Don't pretty-print JSON since it doesn't change anything.
        -- "--compile-commands-dir=root_dir"     -- NOTE: This flag is added dynamically in "root_dir" callback.
    },
    on_attach = function(client, buffer_number)
        require("settings.lsp").common_configuration.on_attach(client, buffer_number)

        -- Load clangd-specific extensions to get commands like header switch - ClangdSwitchSourceHeader.
        require("clangd_extensions") -- TODO: Consider embedding clangd completion scoring.
    end,
}
