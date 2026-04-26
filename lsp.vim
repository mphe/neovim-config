command! LspIncomingCalls Trouble lsp_incoming_calls
command! LspOutgoingCalls Trouble lsp_outgoing_calls

nunmap grt

" nnoremap <leader>ac :Lspsaga code_action<cr>
" nnoremap <leader>ac :lua require("actions-preview").code_actions()<cr>
nnoremap <silent> <leader>ac :lua require("tiny-code-action").code_action()<cr>
nnoremap <leader>fx :lua vim.lsp.buf.code_action({apply=true, context = { only = { "quickfix" } }, })<cr>

nnoremap <leader>d :lua vim.diagnostic.open_float()<cr>
" nnoremap <leader>D :lua vim.diagnostic.setloclist()<cr>
nnoremap <leader>D :Trouble diagnostics<cr>

nnoremap <leader>gi :lua vim.lsp.buf.signature_help()<cr>

nnoremap <f12> :lua vim.lsp.buf.definition()<cr>
nnoremap <leader>jd :lua vim.lsp.buf.definition()<cr>
nmap <leader>jD :vsp<cr><leader>jd
nmap <leader>JD :tab split<cr><leader>jd

nnoremap <leader>pd <cmd>lua require('goto-preview').goto_preview_definition()<CR>
nnoremap <leader>pt <cmd>lua require('goto-preview').goto_preview_type_definition()<CR>
" nnoremap <leader>pi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>
" nnoremap <leader>pD <cmd>lua require('goto-preview').goto_preview_declaration()<CR>
" nnoremap <leader>P <cmd>lua require('goto-preview').close_all_win()<CR>
nnoremap <leader>pr <cmd>lua require('goto-preview').goto_preview_references()<CR>

nnoremap <leader>jt :lua vim.lsp.buf.type_definition()<cr>
nmap <leader>jT :vsp<cr><leader>jt
nmap <leader>JT :tab split<cr><leader>jt

nnoremap <leader>rn :lua vim.lsp.buf.rename()<cr>
nnoremap <leader>jr :Trouble lsp_references<cr>
nnoremap <leader>jR :lua vim.lsp.buf.references()<cr>

function LspEnableDebugLogging()
    lua vim.lsp.set_log_level 'trace'
    lua require('vim.lsp.log').set_format_func(vim.inspect)
endfunction

command! LspServerCapabilities lua =vim.lsp.get_clients()[1].server_capabilities
command! LspEnableDebugLogging call LspEnableDebugLogging()

if has('nvim-0.12')
    command LspLog :lua vim.cmd('tabnew ' .. vim.lsp.log.get_filename())
endif
