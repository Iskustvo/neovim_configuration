-- TODO: Figure out pure Lua way to make it work cross platform.
local total_number_of_system_threads = string.gsub(vim.fn.system("nproc"), "%s*", "")

return {
    lspconfig = {
        -- When nvim-lspconfing computes project root, based on "root_dir" pattern, update clangd invocation command.
        on_new_config = function(config, root_directory)
            config.cmd = {
                "clangd",
                "--compile-commands-dir=" .. root_directory, -- Set correct project root directory.
                "--all-scopes-completion=true",              -- Suggest completion from other namespaces.
                "--background-index=true",                   -- Index project in background and store data in .cache.
                "--background-index-priority=normal",        -- Build index with same priority as interactive work.
                "--clang-tidy=true",                         -- Report clang-tidy diagnostics through LSP.
                "--completion-style=detailed",               -- Do not bundle multiple overloads in 1 completion.
                "--fallback-style=mozilla",                  -- Least useless clang-format style for fallback.
                "--header-insertion=iwyu",                   -- Also include needed headers while doing completion.
                "--header-insertion-decorators=true",        -- Visualise header inclusion in completion.
                -- "--enable-config=true",                   -- TODO: Define default configuration and test it.
                "-j=" .. total_number_of_system_threads,     -- Use all system threads for computation.
                "--malloc-trim=true",                        -- Periodically release unneeded memory.
                "--pch-storage=memory",                      -- Store precompiled headers in memory.
                -- "--log=<value>",                          -- TODO: Investigate error/info/verbose options.
                "--pretty=false",                            -- Don't pretty-print JSON since it doesn't change anything.
            }

            return config
        end,
    },
}
