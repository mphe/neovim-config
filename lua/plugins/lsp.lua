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

-- Monkey patch open_floating_preview() to apply markdown text reflow {{{
local original_open_floating_preview = vim.lsp.util.open_floating_preview

vim.lsp.util.open_floating_preview = function(contents, syntax, opts)
    if syntax ~= 'markdown' then
        return original_open_floating_preview(contents, syntax, opts)
    end

    local reflowed = {}
    local in_code_block = false

    for _, line in ipairs(contents) do
        if line:match('^```') then
            in_code_block = not in_code_block
            table.insert(reflowed, line)
        elseif in_code_block then
            table.insert(reflowed, line)
        else
            line = line:gsub('^%s+', ''):gsub('%s+$', '')

            if line == '' then
                -- Collapse consecutive blank lines into one
                if #reflowed > 0 and reflowed[#reflowed] ~= '' then
                    table.insert(reflowed, '')
                end
            else
                local prev = #reflowed > 0 and reflowed[#reflowed] or nil
                local starts_special = line:match('^[%-%*%+] ')
                or line:match('^%d+%. ')
                or line:match('^#+%s')
                or line:match('^>')
                or line:match('^|')
                or line:match('^%s*[%-%*_][%-%*_][%-%*_]')

                local prev_ends_sentence = prev and prev:match('[%.%!%?%:]%s*$')

                if not prev or prev == '' or starts_special or prev_ends_sentence then
                    table.insert(reflowed, line)
                else
                    reflowed[#reflowed] = reflowed[#reflowed] .. ' ' .. line
                end
            end
        end
    end

    return original_open_floating_preview(reflowed, syntax, opts)
end
-- }}}

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
