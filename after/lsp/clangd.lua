return {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
        "--rename-file-limit=0",
        "--limit-references=0",
        "--header-insertion-decorators",
        -- "--experimental-modules-support",  -- can cause crashes
    },
    settings = {
        clangd = {
        },
    },
}
