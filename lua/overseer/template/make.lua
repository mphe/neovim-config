return {
    name = "Make",
    builder = function()
        return {
            cmd = vim.fn.expandcmd(vim.o.makeprg),
            components = {
                -- Show live build output in a dock at the bottom
                {
                    "open_output",
                    direction = "dock",
                    on_start = "always",
                    focus = false,
                },
                -- { "on_output_quickfix", open_on_exit = "failure" },
                -- { "on_output_quickfix", open_on_exit = "always" },
                -- { "on_output_quickfix", open = false, set_diagnostics = false },
                -- Parse output into task result diagnostics
                { "on_output_parse", errorformat = vim.go.errorformat },
                -- Open trouble when there are diagnostics, close when clean
                { "on_result_diagnostics_trouble", close = true },
                "default",
            },
        }
    end,
    desc = "Run makeprg",
    condition = {
        callback = function()
            return vim.o.makeprg ~= ""
        end,
    },
}
