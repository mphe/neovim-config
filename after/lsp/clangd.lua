return {
    cmd = {
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
    },
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
