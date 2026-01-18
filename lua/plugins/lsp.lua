local utils = require("utils")

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        -- local buf = args.buf

        -- vim.keymap.del('n', 'grt', { buffer = buf })

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
vim.api.nvim_create_autocmd("LspTokenUpdate", {
    callback = function(args)
        local st = vim.lsp.semantic_tokens
        local token = args.data.token

        -- Highlight global/filescope constant variables with @constant
        if
            token.type == "variable"
            and token.modifiers.readonly
            and (token.modifiers.globalScope or token.modifiers.fileScope or token.modifiers.classScope)
            then
                st.highlight_token(token, args.buf, args.data.client_id, "@constant")
            end
        end,
    })

-- Show full diagnostic information
-- https://github.com/neovim/neovim/issues/19649#issuecomment-1750272564
local publishDiagnosticsOriginal = vim.lsp.handlers['textDocument/publishDiagnostics']
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
   publishDiagnosticsOriginal(_, result, ctx, config)
end


vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = vim.g.config_icon_error,
            [vim.diagnostic.severity.WARN] = vim.g.config_icon_warning,
            [vim.diagnostic.severity.INFO] = vim.g.config_icon_info,
            [vim.diagnostic.severity.HINT] = vim.g.config_icon_hint,
        },
        priority = 100,
    },
    float = {
        -- Support URL references in diagnostic message. Supported by LSP spec, but not by Nvim by default.
        format = function(diagnostic)
            local msg = diagnostic.message
            local lsp_data = diagnostic.user_data and diagnostic.user_data.lsp

            if lsp_data and lsp_data.codeDescription and lsp_data.codeDescription.href then
                msg = msg .. "\nMore info: " .. lsp_data.codeDescription.href
            end
            return msg
        end,
    },
    -- virtual_lines = true,
    virtual_text = true,
})

vim.lsp.inlay_hint.enable(true)
vim.highlight.priorities.semantic_tokens = 95

vim.lsp.enable({
    -- 'basedpyright',
    'jedi_language_server',
    'bashls',
    'clangd',
    'csharp_ls',
    'diagnosticls',
    'gdscript',
    'gdshader_lsp',
    'gh_actions_ls',
    'gopls',
    'jsonls',
    -- 'ltex',
    'ltex_plus',
    'lua_ls',
    'tsserver',
    'omnisharp',
    'vimls',
    "rust_analyzer",
})

vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
        "--rename-file-limit=0",
        "--limit-references=0",
        "--header-insertion-decorators",
        -- "--experimental-modules-support",  -- can cause crashes
    },
    settings = {
        clangd = {
        },
    },
})

vim.lsp.config("ltex_plus", {
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

vim.lsp.config("neocmake", {
    init_options = {
        lint = {
            enable = false
        },
        scan_cmake_in_package = false -- default is true
    },
})


-- Pretty hover integration
if utils.has_plugin("pretty_hover") then
    vim.keymap.set('n', 'K', require("pretty_hover").hover, { noremap = true, silent = true })
end

-- Disable lsp logging by default to not infinitely grow the lsp log file
vim.lsp.set_log_level("off")

vim.api.nvim_create_user_command("LspLogClear", function()
    local lsplogpath = vim.fn.stdpath("state") .. "/lsp.log"
    print(lsplogpath)
    if io.close(io.open(lsplogpath, "w+b")) == false then vim.notify("Clearning LSP Log failed.", vim.log.levels.WARN) end
end, { nargs = 0 })
