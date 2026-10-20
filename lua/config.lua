local utils = require("utils")
local localconfig = require("localconfig")

-- Hide markdown header prefixes in nofile buffers (e.g. hover windows, code action, ...)
vim.api.nvim_create_autocmd({"BufWinEnter", "FileType"}, {
    callback = function(args)
        local buf = args.buf
        if vim.bo[buf].filetype ~= "markdown" or vim.bo[buf].buftype ~= "nofile" then
            return
        end

        local ns = vim.api.nvim_create_namespace("hide_markdown_headers")
        vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        for i, line in ipairs(lines) do
            local hashes = line:match("^(#+)%s")
            if hashes then
                vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, {
                    end_col = #hashes + 1,
                    conceal = "",
                })
            end
        end

        vim.wo[vim.fn.bufwinid(buf)].conceallevel = 2
    end,
})

-- Recommended by nvim-tree
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


-- Mason {{{
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
require('mason-tool-installer').setup {
    ensure_installed = { "tree-sitter-cli", }
}
-- }}}

utils.setup_plugin("snacks", {
    input = {
        enabled = true
    },
    styles = {
        input = {
            relative = "cursor",
        }
    }
})

require('goto-preview').setup({
    width = 120,
    height = 45,
    bufhidden = "hide",
})

require("neo-tree").setup({
    -- Prevent truncating (https://github.com/nvim-neo-tree/neo-tree.nvim/issues/486)
    renderers = {
        directory = {
            { "indent" },
            { "icon" },
            { "current_filter" },
            { "name" },
            { "clipboard" },
            { "diagnostics", errors_only = true },
        },
        file = {
            { "indent" },
            { "icon" },
            {
                "name",
                use_git_status_colors = true,
                zindex = 10
            },
            { "clipboard" },
            { "bufnr" },
            { "modified" },
            { "diagnostics" },
            { "git_status" },
        },
    },
    filesystem = {
        bind_to_cwd = true, -- true creates a 2-way binding between vim's cwd and neo-tree's root
        cwd_target = {
            sidebar = "tab",   -- sidebar is when position = left or right
            current = "window" -- current is when position = current
        },
        window = {
            mappings = {
                ["/"] = "noop",
                ["H"] = "noop",
                -- Open file without losing focus
                ["go"] = function(state)
                    state.commands["open"](state)
                    vim.cmd("Neotree reveal")
                end,
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
        {
            filter = { filetype = "markdown" },
            pattern = "%*%*[wW]arning:%*%*",
            hl = "DiagnosticWarn"
        },
        {
            filter = { filetype = "markdown" },
            pattern = "%*%*[nN]ote:%*%*",
            hl = "Todo"
        },
        {
            filter = { filetype = "markdown" },
            pattern = "%*%*[dD]eprecated:%*%*",
            hl = "DiagnosticUnnecessary"
        },
    },
})
-- }}}


if vim.g.config_use_copilot == 1 then
    require("plugins.copilot")
end

require("cpputils")
require("plugins.treesitter")
require("plugins.telescope")
require("plugins.render-markdown")
require("plugins.trouble")
utils.setup_plugin("guess-indent", {
    auto_cmd = true,
})
utils.setup_plugin("windows", {
    animation = {
        enable = false
    },
    ignore = {
        buftype = { "quickfix", "terminal", "prompt", },
        filetype = {
            "NvimTree",
            "neo-tree",
            "undotree",
            "gundo",
            "trouble",
            "dap-repl",
            "dap-disassembly",
            "dapui_console",
            "dapui_scopes",
            "dapui_watches",
            "dapui_stacks",
            "dapui_breakpoints",
            "dap-view",
            "dap-view-term",
            "dap-view-hover",
            "dap-view-help",
            "OverseerList",
            "OverseerOutput",
        }
    },
    autowidth = {
        winwidth = 2 + vim.o.numberwidth,  -- This should perfectly match textwidth + sign column + line numbers
    }
})

utils.setup_plugin("overseer", {
    dap = true,
})
-- Maybe lazy enable using require("overseer").enable_dap()

local function overseer_save_session()
    if not utils.has_plugin("overseer") then
        return {}
    end

    local tasks = require("overseer.task_list").list_tasks()
    local cmds = {}
    for _, task in ipairs(tasks) do
        local json = vim.json.encode(task:serialize())
        -- For some reason, vim.json.encode encodes / as \/.
        json = string.gsub(json, "\\/", "/")
        -- Escape single quotes so we can put this inside single quotes
        json = string.gsub(json, "'", "\\'")
        table.insert(cmds, string.format("lua require('overseer').new_task(vim.json.decode('%s')):start()", json))
    end
    return cmds
end

local function overseer_restore_session()
    local overseer = utils.find_plugin("overseer")

    if overseer then
        for _, task in ipairs(require("overseer").list_tasks({})) do
            task:dispose(true)
        end
    end
end

local has_window_picker = utils.setup_plugin("window-picker", {
    hint = "floating-letter",
})

if has_window_picker then
    vim.keymap.set("n", "<leader>w", function()
        vim.api.nvim_set_current_win(require('window-picker').pick_window())
    end, { noremap = true, silent = true })
end


-- dashboard-nvim {{{
if vim.g.config_use_dashboard == 1 then
    require('dashboard').setup {
        theme = "hyper",
        disable_move = false,
        change_to_vcs_root = true,
        shortcut_type = "number",
        config = {
            shortcut = localconfig.get_dashboard_shortcuts(),
        },
    }
end
-- }}}


if vim.g.config_use_nvimlsp == 1 then
    require("diagnostics")
    require("plugins.lsp")
    require("plugins.dap")
    require("plugins.blink")
    require("lsp-file-operations").setup()
    require("tiny-code-action").setup {
        picker = {
            "buffer",
            opts = {
                hotkeys = true, -- Enable hotkeys for quick selection of actions
                auto_accept = true, -- Automatically accept the selected action (With hotkeys)
                auto_preview = true, -- Enable or disable automatic preview
                winborder = "rounded", -- Border style for picker and preview windows
                keymaps = {
                    close = { "q", "<Esc>" },
                },
            },
        },
    }

    if utils.setup_plugin("pretty_hover") then
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(_)
                vim.keymap.set('n', 'K', require("pretty_hover").hover, { noremap = true, silent = true })
            end,
        })
    end

    require'lsp-lens'.setup({
        enable = false,
    })

    require("plugins.lspsaga")

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

require("custom.inlayhints").setup()  -- must be initialized after lsp-endhints

-- }}}

end

require("plugins.lualine")



-- substitute word under the cursor keybind with vim.ui.input {{{
-- formerly "nnoremap <leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>"

function SubstituteWordUnderCursor()
    local word = vim.fn.expand('<cword>')
    vim.ui.input({ prompt = 'Replace "' .. word .. '" with: ', default = word }, function(input)
        if input and input ~= '' then
            local cmd = '%s/\\<' .. vim.fn.escape(word, '/\\') .. '\\>/' .. vim.fn.escape(input, '/\\') .. '/g'
            vim.fn.histadd(':', cmd)
            vim.cmd(cmd)
        end
    end)
end

vim.keymap.set('n', '<leader>s', SubstituteWordUnderCursor, { noremap = true, silent = true })
-- }}}


require("binds")

utils.setup_plugin("lazydev", {
    library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        "nvim-dap-ui",
    },
})

utils.setup_plugin("auto-session", {
    suppressed_dirs = { "~", "C:/work/documents" },
    save_extra_data = function(_)
        return vim.fn.json_encode({
            breakpoints = require("plugins.dap").save_breakpoints(),
            cmake4vim = {
                build_target = vim.g.cmake_build_target,
                build_dir = vim.g.cmake_build_dir,
                build_type = vim.g.cmake_build_type,
                selected_kit = vim.g.cmake_selected_kit,
                configure_preset = vim.g.cmake_configure_preset,
                build_preset = vim.g.cmake_build_preset,
                test_preset = vim.g.cmake_test_preset,
            },
            compiler = vim.g.current_compiler,
            makeprg = vim.go.makeprg,
        })
    end,
    restore_extra_data = function(_, extra_data)
        local json = vim.fn.json_decode(extra_data)

        require("plugins.dap").restore_breakpoints(json.breakpoints or {})

        local cmake = json.cmake4vim or {}
        vim.g.cmake_build_target = cmake.build_target or vim.g.cmake_build_target
        vim.g.cmake_build_type = cmake.build_type or vim.g.cmake_build_type
        vim.g.cmake_build_dir = cmake.build_dir or vim.g.cmake_build_dir
        vim.g.cmake_selected_kit = cmake.selected_kit or vim.g.cmake_selected_kit
        vim.g.cmake_configure_preset = cmake.configure_preset or vim.g.cmake_configure_preset
        vim.g.cmake_build_preset = cmake.build_preset or vim.g.cmake_build_preset
        vim.g.cmake_test_preset = cmake.test_preset or vim.g.cmake_test_preset

        if json.compiler then
            vim.cmd("compiler! " .. json.compiler)
        end

        vim.go.makeprg = json.makeprg or vim.go.makeprg
    end,
    pre_save_cmds = {
        overseer_save_session,
    },
    pre_restore_cmds = {
        overseer_restore_session,
    }
})


if utils.setup_plugin("disenchant", {
    compile_command_c = "clang -O3 -c %s -o %s",
    compile_command_cpp = "clang++ -O3 -c %s -o %s",
})
then
    vim.api.nvim_create_user_command("Disassemble", "lua require('disenchant').disenchant()", {})
end


