local utils = require("utils")

-- Recommended by nvim-tree
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

utils.setup_plugin("pqf", {
    signs = {
        error = { text = vim.g.config_icon_error, hl = 'DiagnosticSignError' },
        warning = { text  = vim.g.config_icon_warning, hl = 'DiagnosticSignWarn' },
        info = { text = vim.g.config_icon_info, hl = 'DiagnosticSignInfo' },
        hint = { text = vim.g.config_icon_hint, hl = 'DiagnosticSignHint' },
    },
})

require('goto-preview').setup({
    width = 120,
    height = 45,
    bufhidden = "hide",
})

require("neo-tree").setup({
    filesystem = {
        bind_to_cwd = true, -- true creates a 2-way binding between vim's cwd and neo-tree's root
        cwd_target = {
            sidebar = "tab",   -- sidebar is when position = left or right
            current = "window" -- current is when position = current
        },
        window = {
            mappings = {
                ["/"] = "noop",
            },
        },
    }
})
vim.api.nvim_create_user_command("NT", "Neotree toggle reveal_force_cwd", {})

require("plugins.barbar")

-- nvim-scrollbar {{{
if vim.g.config_use_scrollbar == 1 then
require("scrollbar").setup({
    handle = {
        text = " ",
        blend = 0,
        highlight = "CursorLine",
    },
    handlers = {
        diagnostic = true,
        search = false,
        ale = false,
        cursor = false,
    },
})

-- local mark_type_map = {
--     I = "Info",
--     W = "Warn",
--     E = "Error",
-- }
--
-- local function ll_handler(bufnr)
--     local winnr = vim.fn.get(vim.fn.win_findbuf(bufnr), 0, -1)
--     if winnr == -1 then
--         return {}
--     end
--
--     local ll = vim.fn.getloclist(winnr)
--     local marks = {}
--
--     for _, entry in pairs(ll) do
--         if (entry.bufnr or bufnr) == bufnr then
--             table.insert(marks, { line = entry.lnum, type = mark_type_map[entry.type]})
--         end
--     end
--     return marks
-- end
--
-- require("scrollbar.handlers").register("locationlist", ll_handler)
end
-- }}}

-- nvim-notify {{{
require("notify").setup({
    stages = "slide",   -- Animation style (see below for details)
    -- stages = "fade_in_slide_out",
    on_open = nil,      -- Function called when a new window is opened, use for changing win settings/config
    on_close = nil,     -- Function called when a window is closed
    render = "default", -- Render function for notifications. See notify-render()
    timeout = 5000,     -- Default timeout for notifications
    max_width = nil,    -- Max number of columns for messages
    max_height = nil,   -- Max number of lines for a message
    minimum_width = 50, -- Minimum width for notification windows

    -- For stages that change opacity this is treated as the highlight behind the window
    -- Set this to either a highlight group, an RGB hex value e.g. "#000000" or a function returning an RGB code for dynamic values
    background_colour = "Normal",

    -- Icons for the different levels
    icons = {
        ERROR = vim.g.config_icon_error,
        WARN = vim.g.config_icon_warning,
        INFO = vim.g.config_icon_info,
        DEBUG = vim.g.config_icon_hint,
        TRACE = "✎",
    },
})

-- Use plugin for all notifications
vim.notify = require("notify")
-- }}}

-- paint.nvim {{{
require("paint").setup({
    highlights = {
        -- filter can be a table of buffer options that should match,
        -- or a function called with buf as param that should return true.
        -- The example below will paint @something in comments with Constant
        -- {
        --     filter = { filetype = "lua" },
        --     pattern = "%s*%-%-%-%s*(@%w+)",
        --     hl = "Constant",
        -- }
        {
            filter = function(buf)
                local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
                local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
                return buftype == "" and filetype ~= "dashboard"
            end,
            pattern = "%s+$",
            hl = "Error",
        },
        {
            -- Highlight tags in C++
            filter = { filetype = "cpp" },
            pattern = "%[%[([a-zA-Z_]+).-%]%]",
            hl = "Keyword",
        },
        {
            -- Highlight links in markdown that do not have a URL part.
            filter = { filetype = "markdown" },
            pattern = "%[(.-)%]",
            hl = "markdownLinkText",
        },
        {
            filter = { filetype = "python" },
            pattern = "^\\s*(match)",
            hl = "Keyword",
        },
        {
            filter = { filetype = "python" },
            pattern = "\\s+case",
            hl = "Keyword",
        },
    },
})
-- }}}


if vim.g.config_use_copilot == 1 then
    require("plugins.copilot")
end

require("plugins.treesitter")

-- dashboard-nvim {{{
if vim.g.config_use_dashboard == 1 then
    require('dashboard').setup {
        disable_move = false,
        change_to_vcs_root = true,
        shortcut_type = "number"
    }
end
-- }}}

-- telescope {{{
local telescope_actions = require("telescope.actions")
require('telescope').setup{
    defaults = {
        -- preview = false,
        mappings = {
            i = {
                ["<esc>"] = telescope_actions.close,
            },
        },
    },
}

-- }}}

if vim.g.config_use_nvimlsp == 1 then
    require("plugins.lsp")
    require("plugins.blink")
    require("lsp-file-operations").setup()
    require("pretty_hover").setup({})

    require'lsp-lens'.setup({
        enable = false,
    })

-- lspsaga {{{
-- https://nvimdev.github.io/lspsaga/
require("lspsaga").setup {
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
}
-- }}}

-- echo diagnostics {{{
-- https://github.com/seblyng/nvim-echo-diagnostics
require("echo-diagnostics").setup({
    show_diagnostic_number = false,
    show_diagnostic_source = true,
})

vim.api.nvim_create_autocmd("CursorHold", {
    pattern = { "*", },
    callback = require("echo-diagnostics").echo_line_diagnostic,
    group = vim.api.nvim_create_augroup("echo_diagnostics", { clear = true }),
})
-- }}}

-- mason {{{
require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "ltex_plus",
        -- "neocmake",
    },
    automatic_enable = {
        exclude = {}
    }
})
-- }}}

-- lsp-endhints {{{
require("lsp-endhints").setup{
    icons = {
        type = "",
        -- parameter = "",
        -- offspec = "",
        -- unknown = "",
    },
    label = {
        truncateAtChars = 50,
        padding = 1,
        marginLeft = 1,
        sameKindSeparator = ", ",
    },
    autoEnableHints = true,
}

vim.api.nvim_create_user_command("LspEndhintsToggle", require("lsp-endhints").toggle, {})

-- vim.api.nvim_create_autocmd("FileType", {
--     callback = function(args)
--         local bufnr = args.buf
--         local client = vim.lsp.get_client_by_id(args.data.client_id)
--         if client.name == "rust_analyzer" then
--             return
--         end
--         require("lsp-endhints").enable()
--     end,
-- })

-- }}}

-- qfpreview {{{
utils.setup_plugin("qfpreview", {
    ui = {
        -- number | "fill"
        height = 30,
        -- additinonal window configuration
        win = {}
    },
    opts = {
        -- whether to enable lsp clients
        lsp = true,
        -- whether to enable diagnostics
        diagnostics = true
    }
})
-- }}}


end

require("plugins.lualine")
