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
        nerd_font_variant = 'normal',
        use_nvim_cmp_as_default = true,
    },

    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 100,
            update_delay_ms = 100,

            -- Requires the pretty_hover plugin
            draw = function(opts)
                if opts.item and opts.item.documentation and opts.item.documentation.value then
                    local out = require("pretty_hover.parser").parse(opts.item.documentation.value)
                    opts.item.documentation.value = out:string()
                end

                opts.default_implementation(opts)
            end,
        },
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
                -- colorful-menu.nvim
                columns = { { "kind_icon" }, { "label", gap = 1 }, { "source_id" }, },
                components = {
                    label = {
                        text = function(ctx)
                            return require("colorful-menu").blink_components_text(ctx)
                        end,
                        highlight = function(ctx)
                            return require("colorful-menu").blink_components_highlight(ctx)
                        end,
                    },
                },
                -- columns = {
                --     { "kind_icon" },
                --     { "label", "label_description", gap = 1 },
                --     { "source_id" },
                -- },
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
            show_documentation = true
        },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },

        providers = {
            lsp = {
                fallbacks = {},  -- Always show buffer completion
                transform_items = function(_ctx, items)
                    -- Remove auto-completed braces added by the language server
                    for _, item in ipairs(items) do
                        local insertText = item.insertText
                        if insertText ~= nil then
                            -- print(vim.inspect(item))
                            if string.sub(insertText, -1) == "(" then
                                item.insertText = string.sub(insertText, 0, string.len(insertText) - 1)
                            elseif string.sub(insertText, -2) == "()" then
                                item.insertText = string.sub(insertText, 0, string.len(insertText) - 2)
                            end
                        end
                    end
                    return items
                end,
            },
            path = {
                opts = {
                    trailing_slash = false,
                    -- Path completion from cwd instead of current buffer's directory
                    get_cwd = function(_) return vim.fn.getcwd() end,
                },
            },
            buffer = {
                max_items = 100,
                score_offset = -1000,
                opts = {
                    -- get all buffers, even ones like neo-tree
                    get_bufnrs = vim.api.nvim_list_bufs,
                    -- Buffer completion from all open buffers
                    -- get_bufnrs = function()
                    --     return vim.tbl_filter(function(bufnr)
                    --         return vim.bo[bufnr].buftype == ''
                    --     end, vim.api.nvim_list_bufs())
                    -- end
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
        max_typos = function(_) return 1 end,  -- disable the typo resistance
        sorts = {
            -- "exact",
            -- require("clangd_extensions.cmp_scores"),  -- Clangd sorting https://github.com/p00f/clangd_extensions.nvim?tab=readme-ov-file#completion-scores
            "score",
            "sort_text",
        },
    }
}
