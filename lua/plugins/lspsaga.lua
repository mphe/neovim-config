local utils = require("utils")

-- https://nvimdev.github.io/lspsaga/

utils.setup_plugin("lspsaga", {
    ui = {
        border = "rounded",
        button = { "", "" }  -- Remove slanted powerline symbols appearing in floating window titles
    },
    lightbulb = {
        virtual_text = false,
        -- debounce = 0,
    },
    symbol_in_winbar = {
        enable = false,
        separator = ' > ',
        -- color_mode = false,
        show_file = false,
        folder_level = 0,
        hide_keyword = true,
        show_server_name = true,
        only_in_cursor = false,
        delay = 300,
    },
    code_action = {
        keys = {
            quit = { "q", "<esc>" }
        }
    },
    finder = {
        keys = {
            -- shuttle = "<c-w>",
            quit = { "q", "<esc>" },
            toggle_or_open = { "o", "<cr>" }
        },
        layout = "normal",
        -- left_width = 0.2,
        -- right_width = 0.5,
    },
})
