local cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--fallback-style=llvm",
    "--rename-file-limit=0",
    "--limit-references=0",
    "--header-insertion-decorators",
    -- "--experimental-modules-support",  -- can cause crashes
}

-- Expose a global variable `clangd_project_compile_commands_dir` that can be set to specify
-- clangd's fallback compile-commands path.
-- Usually, this should be set in a project-local `.nvim.lua`/`.nvimrc`/`.exrc` file (see `exrc`).
-- This is helpful when working with external dependencies that are not part of the main project
-- directory hierarchy. Since the dependency is located somewhere else and may not have its own
-- compile_commands.json, clangd will not find a suitable compile_commands.json and will also not
-- use the main project's database.
-- This causes clangd to not be able to provide accurate diagnostics and code completion for files
-- from the dependent project.
if vim.g.clangd_project_compile_commands_dir then
    table.insert(cmd, "--compile-commands-dir=" .. vim.g.clangd_project_compile_commands_dir)
end

vim.api.nvim_create_user_command("ClangdCompileCommandsDir", function(opts)
    vim.g.clangd_project_compile_commands_dir = opts.args

    local nvim_lua = vim.fn.getcwd() .. "/.nvim.lua"
    local line = "vim.g.clangd_project_compile_commands_dir = " .. vim.inspect(opts.args)
    vim.fn.writefile({ line }, nvim_lua, "a")
    vim.notify("Updated " .. nvim_lua)
end, { nargs = 1, complete = "dir", desc = "Set clangd compile-commands-dir" })

return {
    cmd = cmd,
    settings = {
        clangd = {
            InlayHints = {
                Enabled = true,
                BlockEnd = false,
                Designators = true,
                ParameterNames = true,
                DeducedTypes = true,
                DefaultArguments = true,
                TypeNameLimit = 0,
            },
        },
    },
}
