local base_cmd = {
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

local config_file = ".clangd_compile_commands_dir"

local function read_compile_commands_dir()
    local path = vim.fn.getcwd() .. "/" .. config_file

    if vim.fn.filereadable(path) == 1 then
        local lines = vim.fn.readfile(path)
        if lines[1] and lines[1] ~= "" then
            return lines[1]
        end
    end

    return nil
end

-- Reads the fallback compile-commands dir from a project-local `.clangd_compile_commands_dir` file.
-- This is helpful when working with external dependencies that are not part of the main project
-- directory hierarchy. Since the dependency is located somewhere else and may not have its own
-- compile_commands.json, clangd will not find a suitable compile_commands.json and will also not
-- use the main project's database.
-- This causes clangd to not be able to provide accurate diagnostics and code completion for files
-- from the dependent project.
vim.api.nvim_create_user_command("ClangdCompileCommandsDir", function(opts)
    local path = vim.fn.getcwd() .. "/" .. config_file
    vim.fn.writefile({ opts.args }, path)
    vim.cmd("silent! lsp restart clangd")
end, { nargs = 1, complete = "dir", desc = "Set clangd compile-commands-dir" })


local function cmd(dispatchers, config)
    local result = vim.deepcopy(base_cmd)
    local dir = read_compile_commands_dir()
    if dir then
        table.insert(result, "--compile-commands-dir=" .. dir)
    end
    return vim.lsp.rpc.start(result, dispatchers, { cwd = config.cmd_cwd })
end

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
