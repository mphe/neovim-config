local utils = require("utils")

local default_win_options = {
    conceallevel = { default = vim.o.conceallevel, rendered = 3 },
    concealcursor = { default = vim.o.concealcursor, rendered = "" },
}

local default_code_options = {
    width = "block",
    right_pad = 1,
    highlight = 'RenderMarkdownCode',
    highlight_border = "RenderMarkdownCodeBorder",
    highlight_inline = "markdownCode",
    language = true,
    border = "thin",
}


utils.setup_plugin("render-markdown", {
    file_types = { 'markdown', 'vimwiki', 'copilot-chat' },
    render_modes = true,
    anti_conceal = {
        -- enabled = false,
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
    win_options = default_win_options,
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
            -- CopilotChat window has buftype nofile, so we need a filetype entry which cancels-out the nofile override
            ["copilot-chat"] = {
                anti_conceal = {
                    enabled = true,
                },
                win_options = default_win_options,
                code = default_code_options,
            }
        }
    },
    heading = { enabled = false },
    paragraph = { enabled = false },
    code = default_code_options,
    -- dash = { enabled = false },
    -- bullet = { enabled = false },
    -- checkbox = { enabled = false },
    quote = {
        repeat_linebreak = true,
    },
    pipe_table = {
        enabled = true,
        alignment_indicator = "",
    },
    -- callout = { enabled = false },
    -- link = { enabled = false },
    sign = { enabled = false },
    indent = { enabled = false },
    -- html = { enabled = false },
    -- latex = { enabled = false },
})
