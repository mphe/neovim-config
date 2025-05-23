local icon_error = vim.g.config_icon_error
local icon_warning = vim.g.config_icon_warning
local icon_info = vim.g.config_icon_info
local icon_hint = vim.g.config_icon_hint

-- Recommended by nvim-tree
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("lsp-file-operations").setup()

-- nvim-tree {{{
local function nvim_tree_on_attach(bufnr)
    local api = require("nvim-tree.api")

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    api.config.mappings.default_on_attach(bufnr)

    -- remove a default
    vim.keymap.del("n", "H", { buffer = bufnr })
    vim.keymap.del("n", "L", { buffer = bufnr })

    -- override a default
    -- vim.keymap.set("n", "<C-e>", api.tree.reload,                       opts("Refresh"))

    -- add your mappings
    -- vim.keymap.set("n", "?",     api.tree.toggle_help,                  opts("Help"))
end

require("nvim-tree").setup({
    on_attach = nvim_tree_on_attach,
})

vim.api.nvim_create_user_command("NT", "NvimTreeToggle", {})
-- }}}

-- barbar.nvim {{{
-- config {{{
vim.g.barbar_auto_setup = false
require'bufferline'.setup {
  -- Enable/disable animations
  animation = true,

  -- Enable/disable auto-hiding the tab bar when there is a single buffer
  auto_hide = false,

  -- Enable/disable current/total tabpages indicator (top right corner)
  tabpages = true,

  -- Enables/disable clickable tabs
  --  - left-click: go to buffer
  --  - middle-click: delete buffer
  clickable = true,

  -- Excludes buffers from the tabline
  -- exclude_ft = {'javascript'},
  -- exclude_name = {'package.json'},

  -- A buffer to this direction will be focused (if it exists) when closing the current buffer.
  -- Valid options are 'left' (the default) and 'right'
  focus_on_close = 'previous',

  -- Hide inactive buffers and file extensions. Other options are `alternate`, `current`, and `visible`.
  hide = {extensions = false, inactive = false},

  -- Disable highlighting alternate buffers
  highlight_alternate = false,

  -- Disable highlighting file icons in inactive buffers
  highlight_inactive_file_icons = false,

  -- Enable highlighting visible buffers
  highlight_visible = true,

  icons = {
    preset = "powerline",
    -- preset = "slanted",
    -- separator_at_end = false,
    -- Configure the base icons on the bufferline.
    buffer_index = false,
    buffer_number = false,
    button = '',
    -- Enables / disables diagnostic symbols
    diagnostics = {
      [vim.diagnostic.severity.ERROR] = {enabled = false, icon = icon_error},
      [vim.diagnostic.severity.WARN] = {enabled = false, icon = icon_warning},
      [vim.diagnostic.severity.INFO] = {enabled = false, icon = icon_info},
      [vim.diagnostic.severity.HINT] = {enabled = false, icon = icon_hint},
    },
    filetype = {
      -- Sets the icon's highlight group.
      -- If false, will use nvim-web-devicons colors
      custom_colors = false,

      -- Requires `nvim-web-devicons` if `true`
      enabled = true,
    },

    -- Configure the icons on the bufferline when modified or pinned.
    -- Supports all the base icon options.
    modified = {button = '●'},
    pinned = {button = ''},

    gitsigns = { enabled = false },

    -- separator = {left = '', right = ''},
    -- inactive = {separator = {left = '', right = ''}, button = '×'},

    -- separator = {left = '', right = ' '},
    -- inactive = {separator = {left = '', right = ' '}, button = '×'},
    -- inactive = {separator = {left = '🭛', right = '🭦'}, button = '×'},
    -- separator = {left = '🭛', right = '🭦'},
    -- separator = {left = '▎', right = ''},
    -- separator = {left = '', right = ''},
    -- inactive = {separator = {left = '', right = ''}, button = '×'},
    -- separator = {left = '', right = " \u{e0ba}"},
    -- inactive = {separator = {left = '', right = '\u{e0bd} '}, button = '×'},
    -- inactive = {separator = {left = '', right = ''}, button = '×'},
    -- separator = {left = '', right = ''},


    -- Configure the icons on the bufferline based on the visibility of a buffer.
    -- Supports all the base icon options, plus `modified` and `pinned`.
    -- alternate = {filetype = {enabled = false}},
    -- current = {buffer_index = false},
    -- inactive = {button = '×'},
    -- visible = {modified = {buffer_number = false}},
  },

  -- If true, new buffers will be inserted at the start/end of the list.
  -- Default is to insert after current buffer.
  insert_at_end = true,
  insert_at_start = false,

  -- Sets the maximum padding width with which to surround each tab
  maximum_padding = 2,

  -- Sets the minimum padding width with which to surround each tab
  minimum_padding = 1,

  -- Sets the maximum buffer name length.
  maximum_length = 30,

  -- If set, the letters for each buffer in buffer-pick mode will be
  -- assigned based on their name. Otherwise or in case all letters are
  -- already assigned, the behavior is to assign letters in order of
  -- usability (see order below)
  semantic_letters = true,

  -- New buffer letters are assigned in this order. This order is
  -- optimal for the qwerty keyboard layout but might need adjustement
  -- for other layouts.
  letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

  -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
  -- where X is the buffer number. But only a static string is accepted here.
  no_name_title = nil,
}

-- }}}
-- mappings {{{

-- Aliases for muscle memory
vim.cmd [[
  cnoreabbrev bf BufferFirst
  cnoreabbrev bl BufferLast
  cnoreabbrev bd BufferClose
]]

-- Move to previous/next
vim.keymap.set("n", "<leader>bp", "<Cmd>BufferPrevious<CR>", { silent = true })
vim.keymap.set("n", "<leader>bn", "<Cmd>BufferNext<CR>", { silent = true })
-- Re-order to previous/next
vim.keymap.set("n", "<leader>b<", "<Cmd>BufferMovePrevious<CR>", { silent = true })
vim.keymap.set("n", "<leader>b>", "<Cmd>BufferMoveNext<CR>", { silent = true })
-- Goto buffer in position...
vim.keymap.set("n", "<leader>1", "<Cmd>BufferGoto 1<CR>", { silent = true })
vim.keymap.set("n", "<leader>2", "<Cmd>BufferGoto 2<CR>", { silent = true })
vim.keymap.set("n", "<leader>3", "<Cmd>BufferGoto 3<CR>", { silent = true })
vim.keymap.set("n", "<leader>4", "<Cmd>BufferGoto 4<CR>", { silent = true })
vim.keymap.set("n", "<leader>5", "<Cmd>BufferGoto 5<CR>", { silent = true })
vim.keymap.set("n", "<leader>6", "<Cmd>BufferGoto 6<CR>", { silent = true })
vim.keymap.set("n", "<leader>7", "<Cmd>BufferGoto 7<CR>", { silent = true })
vim.keymap.set("n", "<leader>8", "<Cmd>BufferGoto 8<CR>", { silent = true })
vim.keymap.set("n", "<leader>9", "<Cmd>BufferGoto 9<CR>", { silent = true })
vim.keymap.set("n", "<leader>0", "<Cmd>BufferLast<CR>", { silent = true })
vim.keymap.set("n", "<leader>bL", "<Cmd>BufferLast<CR>", { silent = true })
vim.keymap.set("n", "<leader>bF", "<Cmd>BufferFirst<CR>", { silent = true })
-- Pin/unpin buffer
-- vim.keymap.set("n", "<leader>p", "<Cmd>BufferPin<CR>", { silent = true })
-- Close buffer
vim.keymap.set("n", "<leader>bd", "<Cmd>BufferClose<CR>", { silent = true })
-- Wipeout buffer
--                          :BufferWipeout
-- Close commands
--                          :BufferCloseAllButCurrent
--                          :BufferCloseAllButPinned
--                          :BufferCloseAllButCurrentOrPinned
--                          :BufferCloseBuffersLeft
--                          :BufferCloseBuffersRight
-- Magic buffer-picking mode
vim.keymap.set("n", "<leader>B", "<Cmd>BufferPick<CR>", { silent = true })
-- Sort automatically by...
-- nnoremap <silent> <Space>bb <Cmd>BufferOrderByBufferNumber<CR>
-- nnoremap <silent> <Space>bd <Cmd>BufferOrderByDirectory<CR>
-- nnoremap <silent> <Space>bl <Cmd>BufferOrderByLanguage<CR>
-- nnoremap <silent> <Space>bw <Cmd>BufferOrderByWindowNumber<CR>
--
-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used
-- }}}
-- }}}

-- nvim-scrollbar {{{
if vim.g.config_use_scrollbar == 1 then
require("scrollbar").setup({
    handle = {
        text = " ",
        highlight = "Pmenu",
    },
    -- marks = {
    --     Search = { text = { "-", "=" }, priority = 0, highlight = "orange" },
    --     Error = { text = { "-", "=" }, priority = 1, highlight = "red" },
    --     Warn = { text = { "-", "=" }, priority = 2, highlight = "CocWarningSign" },
    --     Info = { text = { "-", "=" }, priority = 3, highlight = "CocInfoSign" },
    --     Hint = { text = { "-", "=" }, priority = 4, color = "green" },
    --     Misc = { text = { "-", "=" }, priority = 5, color = "purple" },
    -- },
    -- excluded_filetypes = {
    --     "",
    --     "prompt",
    --     "TelescopePrompt",
    -- },
    -- autocmd = {
    --     render = {
    --         "BufWinEnter",
    --         "TabEnter",
    --         "TermEnter",
    --         "WinEnter",
    --         "CmdwinLeave",
    --         "TextChanged",
    --         "VimResized",
    --         "WinScrolled",
    --         "InsertLeave",
    --     },
    -- },
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
        ERROR = icon_error,
        WARN = icon_warning,
        INFO = icon_info,
        DEBUG = icon_hint,
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
            pattern = "%[%[(.-)%]%]",
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
        -- Highlight 'self'.
        {
            filter = { filetype = "python" },
            pattern = "%f[%a]self%f[%A]",
            hl = "Identifier",
        },
        -- Treat uppercase identifiers as constants. Overrides semantic tokens.
        {
            filter = { filetype = "python" },
            pattern = "%f[%a0-9_][A-Z0-9_]+%f[^%a0-9_]",
            hl = "Constant",
        },
    },
})
-- }}}


-- copilot-client.lua {{{
if vim.g.config_use_copilot == 1 then
    require("copilot").setup()

    function copilot_show()
        require("copilot.suggestion").next()
    end

    function copilot_cancel()
        if require("copilot.suggestion").is_visible() then
            require("copilot.suggestion").dismiss()
        end
    end

    function copilot_accept()
        if require("copilot.suggestion").is_visible() then
            require("copilot.suggestion").accept()
            copilot_cancel()
            return true
        end

        return false
    end

    vim.api.nvim_create_autocmd("InsertLeave", {
        command = "silent! lua copilot_cancel()",
        group = vim.api.nvim_create_augroup("custom_copilot_trigger", { clear = true }),
    })

    vim.api.nvim_set_keymap('i', '<C-c>', '<cmd>lua copilot_show()<CR>', { noremap = true, silent = true })

    -- require('copilot-client').setup {
    --   mapping = {
    --     accept = '<CR>',
    --     -- Next and previos suggestions to be added
    --     -- suggest_next = '<C-n>',
    --     -- suggest_prev = '<C-p>',
    --   },
    -- }

    -- Create a keymap that triggers the suggestion.
    -- vim.api.nvim_set_keymap('i', '<C-c>', '<cmd>lua require("copilot-client").suggest()<CR>', { noremap = true, silent = true })
end
-- }}}

-- treesitter {{{
local use_treesitter = false
local enabled_highlights = {
    -- gdscript = true,
    -- gdshader = true,
}

if use_treesitter then
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
end

require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = {
        "markdown",
        "markdown_inline",
        "c",
        "cpp",
        "gdscript",
        -- "gdshader",
        "go",
        "python",
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = false,

    -- List of parsers to ignore installing (or "all")
    -- ignore_install = { "javascript" },

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    indent = {
        enable = false
    },
    highlight = {
        enable = use_treesitter,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        -- disable = { "c", "rust" },
        disable = function(lang, _buf)
            return enabled_highlights[lang] == nil
            -- Disable slow treesitter highlight for large files
            -- local max_filesize = 100 * 1024 -- 100 KB
            -- local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            -- if ok and stats and stats.size > max_filesize then
            --     return true
            -- end
        end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = {},
    },
}

require("nvim-treesitter.install").prefer_git = true
-- }}}

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
-- lspconfig {{{
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

        -- Fix gopls semantic tokens: https://github.com/golang/go/issues/54531#issuecomment-1464982242
        if client.name == 'gopls' and not client.server_capabilities.semanticTokensProvider then
            local semantic = client.config.capabilities.textDocument.semanticTokens
            client.server_capabilities.semanticTokensProvider = {
                full = true,
                legend = {tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes},
                range = true,
            }
        end
    end,
})

-- Custom highlight conditions (https://github.com/neovim/neovim/pull/22022)
local st = vim.lsp.semantic_tokens
vim.api.nvim_create_autocmd("LspTokenUpdate", {
    callback = function(args)
        local token = args.data.token

        -- Highlight global/filescope constant variables with @constant
        if
            token.type == "variable"
            and token.modifiers.readonly
            and (token.modifiers.globalScope or token.modifiers.fileScope)
            then
                st.highlight_token(token, args.buf, args.data.client_id, "@constant")
            end
        end,
    })

-- Show full diagnostic information
-- https://github.com/neovim/neovim/issues/19649#issuecomment-1750272564
local original = vim.lsp.handlers['textDocument/publishDiagnostics']
vim.lsp.handlers['textDocument/publishDiagnostics'] = function(_, result, ctx, config)
    vim.tbl_map(function(item)
        if item.relatedInformation and #item.relatedInformation > 0 then
            vim.tbl_map(function(k)
                if k.location then
                    local tail = vim.fn.fnamemodify(vim.uri_to_fname(k.location.uri), ':t')
                    k.message = tail ..
                    '(' .. (k.location.range.start.line + 1) .. ', ' .. (k.location.range.start.character + 1) ..
                    '): ' .. k.message

               if k.location.uri == vim.uri_from_bufnr(0) then
                  table.insert(result.diagnostics, {
                     code = item.code,
                     message = k.message,
                     range = k.location.range,
                     severity = vim.lsp.protocol.DiagnosticSeverity.Hint,
                     source = item.source,
                     relatedInformation = {},
                  })
               end
            end
            item.message = item.message .. '\n' .. k.message
         end, item.relatedInformation)
      end
   end, result.diagnostics)
   original(_, result, ctx, config)
end

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = icon_error,
            [vim.diagnostic.severity.WARN] = icon_warning,
            [vim.diagnostic.severity.INFO] = icon_info,
            [vim.diagnostic.severity.HINT] = icon_hint,
        },
        priority = 100,
    },
    -- virtual_lines = true,
    virtual_text = true,
})

vim.lsp.inlay_hint.enable(true)
vim.highlight.priorities.semantic_tokens = 95

vim.lsp.enable({
    'basedpyright',
    -- 'jedi_language_server',
    'bashls',
    'clangd',
    'cmake',
    'csharp_ls',
    'diagnosticls',
    'gdscript',
    'gdshader_lsp',
    'gh_actions_ls',
    'gopls',
    'jsonls',
    'ltex',
    'lua_ls',
    'tsserver',
    'omnisharp',
    'vimls',
})

vim.lsp.config("basedpyright", {
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
})

vim.lsp.config("gopls", {
    settings = {
        ["gopls"] = {
            gofumpt = true,
            codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
            },
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
            analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
            },
            semanticTokens = true,
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
        },
    },
})
-- }}}

-- blink.cmp {{{
-- https://cmp.saghen.dev/installation
require("blink.cmp").setup {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
        preset = 'default',
        -- ['<Tab>'] = { 'insert_next', 'fallback' },
        -- ['<S-Tab>'] = { 'insert_prev', 'fallback' },
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<CR>'] = { "accept", "fallback_to_mappings" },
        ['<C-e>'] = { "fallback_to_mappings" },
        ['<c-f>'] = { 'scroll_documentation_down', 'fallback' },
        ['<c-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<c-j>'] = { 'snippet_forward', 'fallback' },
        -- ['<C-space>'] = { "show", "fallback" },
    },

    cmdline = {
        keymap = {
            preset = "none",
            -- ['<Tab>'] = { 'show_and_insert', 'accept' },
            -- ['<Tab>'] = { 'show', 'accept' },
        },
        completion = { menu = { auto_show = false } }
    },

    appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
        use_nvim_cmp_as_default = true,
    },

    completion = {
        documentation = { auto_show = true },
        accept = {
            auto_brackets = { enabled = false },
            create_undo_point = true,
        },
        list = {
            selection = {
                preselect = false,
                auto_insert = true
            },
        },
        menu = {
            auto_show = true,
            draw = {
                columns = {
                    { "kind_icon" },
                    { "label", "label_description", gap = 1 },
                    { "source_id" },
                    -- { "label", "label_description", gap = 1 },
                    -- { "kind_icon", "kind" }
                },
            }
        },
        ghost_text = { enabled = false },
        trigger = {
            -- When true, will prefetch the completion items when entering insert mode
            prefetch_on_insert = true,
        },
    },

    signature = {
        enabled = true,
        window = {
            -- border = "none",
            -- show_documentation = false
        },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },

        providers = {
            path = {
                opts = {
                    -- Path completion from cwd instead of current buffer's directory
                    get_cwd = function(_)
                        return vim.fn.getcwd()
                    end,
                },
            },
            buffer = {
                opts = {
                    -- Buffer completion from all open buffers
                    get_bufnrs = function()
                        return vim.tbl_filter(function(bufnr)
                            return vim.bo[bufnr].buftype == ''
                        end, vim.api.nvim_list_bufs())
                    end
                }
            }
        }
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = {
        implementation = "prefer_rust_with_warning",
        sorts = {
            "exact",
            "score",
            "sort_text",
        },
    }
}

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
        -- enable = false,
        separator = ' > ',
        -- color_mode = false,
        -- show_file = false,
        -- folder_level = 0,
        hide_keyword = true,
        show_server_name = true,
        only_in_cursor = false,
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
    breadcrumbs = {
        delay = 300,
    }
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
end
