return {
    settings = {
        basedpyright = {
            analysis = {
                inlayHints = {
                    callArgumentNames = false
                },
                typeCheckingMode = "off",  -- Use mypy for type checking
                -- diagnosticMode = "workspace",
            },
        },
    },
}
