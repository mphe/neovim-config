command! LspIncomingCalls Lspsaga incoming_calls
command! LspOutgoingCalls Lspsaga outgoing_calls

nnoremap <leader>ac :Lspsaga code_action<cr>
nnoremap <leader>fx :lua vim.lsp.buf.code_action({apply=true, context = { only = { "quickfix" } }, })<cr>

" nnoremap <leader>d :Lspsaga show_line_diagnostics<cr>
" nnoremap <leader>D :Lspsaga show_buf_diagnostics<cr>
nnoremap <leader>d :lua vim.diagnostic.open_float()<cr>
nnoremap <leader>D :lua vim.diagnostic.setloclist()<cr>

nnoremap <leader>gi :lua vim.lsp.buf.signature_help()<cr>

nnoremap <f12> :lua vim.lsp.buf.definition()<cr>
nnoremap <leader>jd :lua vim.lsp.buf.definition()<cr>
nmap <leader>jD :vsp<cr><leader>jd
nmap <leader>JD :tab split<cr><leader>jd

nnoremap <leader>pd :Lspsaga peek_definition<cr>

nnoremap <leader>jt :lua vim.lsp.buf.type_definition()<cr>
nmap <leader>jT :vsp<cr><leader>jt
nmap <leader>JT :tab split<cr><leader>jt

nnoremap <leader>rn :Lspsaga rename<cr>
nnoremap <leader>jr :Lspsaga finder<cr>
nnoremap <leader>jR :lua vim.lsp.buf.references()<cr>

cnoreabbrev Lsp Lspsaga

function LspEnableDebugLogging()
    lua vim.lsp.set_log_level 'trace'
    lua require('vim.lsp.log').set_format_func(vim.inspect)
endfunction

command! LspServerCapabilities lua =vim.lsp.get_clients()[1].server_capabilities
command! LspEnableDebugLogging call LspEnableDebugLogging()


" unmap default nvim LSP binding
nunmap grt
