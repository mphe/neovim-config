local M = {}

-- Show full diagnostic information
-- https://github.com/neovim/neovim/issues/19649#issuecomment-1750272564
local publishDiagnosticsOriginal = vim.lsp.handlers['textDocument/publishDiagnostics']

local function publishDiagnosticsCustom(_, result, ctx, config)
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
            -- -- We could append it to the main message here or we can do it in the diagnostic format handler.
            -- item.message = item.message .. '\n' .. k.message
            item.message = item.message
         end, item.relatedInformation)
      end
   end, result.diagnostics)
   publishDiagnosticsOriginal(_, result, ctx, config)
end


vim.lsp.handlers['textDocument/publishDiagnostics'] = publishDiagnosticsCustom

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
        -- Use custom suffix and format handlers to show URL references and related information in
        -- diagnostic messages. Supported by LSP spec, but not by Nvim by default.
        format = function(diagnostic)
            local msg = diagnostic.message
            local lsp_data = diagnostic.user_data and diagnostic.user_data.lsp

            if lsp_data and lsp_data.relatedInformation then
                local infos = vim.tbl_map(function(info)
                    return info.message
                end, lsp_data.relatedInformation)
                if #infos > 0 then
                    msg = string.format("%s\n⮡  %s", msg, table.concat(infos, "\n⮡  "))
                end
            end

            return msg .. "\n"  -- Force suffix on new line
        end,
        prefix = function(diagnostic)
            local hl = {
                [vim.diagnostic.severity.ERROR] = "DiagnosticError",
                [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
                [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
                [vim.diagnostic.severity.HINT] = "DiagnosticHint",
            }
            return string.format("%s ", vim.diagnostic.config().signs.text[diagnostic.severity] or ""), hl[diagnostic.severity] or ""
        end,
        suffix = function(diagnostic)
            local code = diagnostic.code
            local lsp_data = diagnostic.user_data and diagnostic.user_data.lsp

            if code and lsp_data and lsp_data.codeDescription and lsp_data.codeDescription.href then
                return string.format("[%s](%s)", code, lsp_data.codeDescription.href), "markdownLinkText"
            elseif code then
                return string.format("[%s]", code)
            end
            return ""
        end,
    },
    -- virtual_lines = true,
    virtual_text = true,
})


local orig_open_float = vim.diagnostic.open_float
vim.diagnostic.open_float = function(opts, ...)
    local float_bufnr, win_id = orig_open_float(opts, ...)
    if float_bufnr then
        vim.bo[float_bufnr].filetype = 'markdown'
        vim.wo[win_id].conceallevel = 2
        vim.wo[win_id].concealcursor = 'nv'
    end
    return float_bufnr, win_id
end


return M
