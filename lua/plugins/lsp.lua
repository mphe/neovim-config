local utils = require("utils")

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(_args)
        -- local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        -- local buf = args.buf

        -- vim.keymap.del('n', 'grt', { buffer = buf })
    end,
})

-- Custom highlight conditions (https://github.com/neovim/neovim/pull/22022)
vim.api.nvim_create_autocmd("LspTokenUpdate", {
    callback = function(args)
        local st = vim.lsp.semantic_tokens
        local token = args.data.token

        -- Highlight global/filescope constant variables with @constant
        if token.type == "variable"
            and token.modifiers.readonly
            and (token.modifiers.globalScope or token.modifiers.fileScope or token.modifiers.classScope) then
            st.highlight_token(token, args.buf, args.data.client_id, "@constant")
        end
    end,
})

local hover_highlights = {
    { pattern = '%*%*[wW]arning:%*%*', hl = 'DiagnosticWarn' },
    { pattern = '%*%*[nN]ote:%*%*', hl = 'Todo' },
    { pattern = '%*%*[dD]eprecated:%*%*', hl = 'DiagnosticUnnecessary' },
}

-- Apply custom highlights and conceals to the LSP hover content
vim.api.nvim_create_autocmd('WinNew', {
    callback = function()
        local win = vim.api.nvim_get_current_win()
        local config = vim.api.nvim_win_get_config(win)
        local ns = vim.api.nvim_create_namespace('custom_hover_hl')
        if config.relative == '' then return end

        vim.defer_fn(function()
            if not vim.api.nvim_win_is_valid(win) then
                return
            end
            local bufnr = vim.api.nvim_win_get_buf(win)
            local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            for i, line in ipairs(lines) do
                -- Conceal "#" markdown header prefix
                local _, end_col = line:find('^#+%s?')
                if end_col then
                    vim.api.nvim_buf_set_extmark(bufnr, ns, i - 1, 0, {
                        end_col = end_col,
                        conceal = '',
                    })
                end

                -- Apply custom highlights
                for _, entry in ipairs(hover_highlights) do
                    local start = 1
                    while true do
                        local s, e = line:find(entry.pattern, start)
                        if not s then break end
                        vim.api.nvim_buf_set_extmark(bufnr, ns, i - 1, s - 1, {
                            end_col = e,
                            hl_group = entry.hl,
                            priority = 200,
                        })
                        start = e + 1
                    end
                end
            end

            vim.wo[win].conceallevel = 2
            vim.wo[win].concealcursor = 'nv'
        end, 50)
    end,
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
    "arduino_language_server",
})


-- Only log LSP errors by default to not infinitely grow the lsp log file
vim.lsp.set_log_level("ERROR")

vim.api.nvim_create_user_command("LspLogClear", function()
    local lsplogpath = vim.fn.stdpath("state") .. "/lsp.log"
    if io.close(io.open(lsplogpath, "w+b")) == false then
        vim.notify("Clearning LSP Log failed.", vim.log.levels.WARN)
    end
end, { nargs = 0 })
