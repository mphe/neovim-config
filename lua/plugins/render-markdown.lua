local utils = require("utils")

local default_options = {
    anti_conceal = {
        enabled = true,
        -- ignore = {
        --     -- code_background = false,
        --     -- indent = false,
        --     -- sign = false,
        --     -- virtual_lines = false,
        --     -- bullet = false,
        --     -- callout = false,
        --     -- check_icon = false,
        --     -- check_scope = false,
        --     -- code_border = false,
        --     -- code_language = false,
        --     -- dash = true,
        --     -- head_background = false,
        --     -- head_border = false,
        --     -- head_icon = false,
        --     -- indent = false,
        --     -- link = false,
        --     -- quote = false,
        --     -- sign = false,
        --     -- table_border = false,
        --     -- virtual_lines = false,
        -- },
    },
    win_options = {
        conceallevel = { default = vim.o.conceallevel, rendered = 3 },
        concealcursor = { default = vim.o.concealcursor, rendered = "" },
    },
    code = {
        width = "block",
        right_pad = 1,
        highlight = 'RenderMarkdownCode',
        highlight_border = "RenderMarkdownCodeBorder",
        highlight_inline = "markdownCode",
        language = true,
        border = "thin",
    },
}


utils.setup_plugin("render-markdown", {
    file_types = { 'markdown', 'vimwiki', 'copilot-chat', 'codecompanion' },
    render_modes = true,
    anti_conceal = default_options.anti_conceal,
    win_options = default_options.win_options,
    overrides = {
        buftype = {
            nofile = {
                anti_conceal = {
                    enabled = false,
                },
                win_options = {
                    conceallevel = { default = vim.o.conceallevel, rendered = 3 },
                    concealcursor = { default = vim.o.concealcursor, rendered = "nvic" },
                },
                code = {
                    style = "normal",
                    highlight = "",
                    highlight_border = "",
                    border = "hide",
                },
            },
        },
        filetype = {
            -- CopilotChat/CodeCompanion window has buftype nofile, so we need a filetype entry which cancels-out the nofile override
            ["copilot-chat"] = default_options,
            ["codecompanion"] = default_options,
        }
    },
    heading = { enabled = false },
    paragraph = { enabled = false },
    code = default_options.code,
    quote = {
        repeat_linebreak = true,
    },
    pipe_table = {
        enabled = true,
        alignment_indicator = "",
    },
    sign = { enabled = false },
    indent = { enabled = false },
    -- dash = { enabled = false },
    -- bullet = { enabled = false },
    -- checkbox = { enabled = false },
    -- callout = { enabled = false },
    -- link = { enabled = false },
    -- html = { enabled = false },
    -- latex = { enabled = false },
})
