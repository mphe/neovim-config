return {
    on_attach = function(_, _)
        require("ltex_extra").setup {
            load_langs = { "en-US", "de-DE", },
            path = vim.fn.expand("~") .. "/.ltex",
        }
    end,
    filetypes = { "bib", "tex", "markdown", "bib", },
    settings = {
        ltex = {
            -- language = "de-DE",
            -- language = "en-US",
            diagnosticSeverity = "information",
            disabledRules = {
                ["en-US"] = {
                    "WHITESPACE_RULE",
                }
            },
            enabled = {
                "bib",
                "latex",
                "tex",
                "markdown"
            }
            -- dictionary = {
            --     ["en-US"] = { ":~/.ltex/en-US.txt" },
            --     ["de-DE"] = { ":~/.ltex/de-DE.txt" },
            -- },
        },
    },
}
