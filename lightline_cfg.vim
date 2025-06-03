" lightline related configs
scriptencoding utf-8

let s:diagnostic_symbols = {
            \ 'error': g:config_icon_error . ' ',
            \ 'warning': g:config_icon_warning . ' ',
            \ 'info': g:config_icon_info . ' '
            \ }

" lightline {{{

let g:lightline = {}
let g:lightline.enable = { 'statusline': 1, 'tabline': 0 }
let g:lightline.colorscheme = 'custom_solarized'

" let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.separator = { 'left': '', 'right': '' }
" let g:lightline.subseparator = { 'left': '', 'right': '' }
" let g:lightline.tabline_subseparator = { 'left': '', 'right': '' }
let g:lightline.tabline_separator =  { 'left': '', 'right': '' }

" let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': '', 'right': '' }
let g:lightline.tabline_subseparator = { 'left': '', 'right': '' }
" let g:lightline.tabline_separator =  { 'left': '', 'right': '' }

" let g:lightline.separator = { 'left': '█', 'right': '█' }
" let g:lightline.tabline_separator =  { 'left': '█', 'right': '█' }

" let g:lightline.separator = { 'left': "\u258c", 'right': "\u2590" }
" let g:lightline.separator = { 'left': "\u2599", 'right': "\u259f" }

" requires powerline font
" let g:lightline.separator = { 'left': "\ue0b8", 'right': "\ue0be" }
" let g:lightline.subseparator = { 'left': "\ue0b9", 'right': "\ue0b9" }
" let g:lightline.tabline_separator = { 'left': "\ue0bc", 'right': "\ue0ba" }
" let g:lightline.tabline_subseparator = { 'left': "\ue0bb", 'right': "\ue0bb" }

" let g:lightline.separator = { 'left': "\u25e3", 'right': "\u25e2" }
" let g:lightline.subseparator = { 'left': "\ue0b9", 'right': "\ue0b9" }
" let g:lightline.tabline_separator = { 'left': "\ue0bc", 'right': "\ue0ba" }
" let g:lightline.tabline_subseparator = { 'left': "\ue0bb", 'right': "\ue0bb" }

" \ 'separator': { 'left': '█', 'right': '█' },
" \ 'subseparator': { 'left': '|', 'right': '|' },
" \ 'tabline_subseparator': { 'left': '', 'right': '' },
" \ 'tabline_separator':  { 'left': '█', 'right': '█' },
" \ 'separator': { 'left': '', 'right': '' },
" \ 'subseparator': { 'left': '', 'right': '' },
" \ 'tabline_subseparator': { 'left': '', 'right': '' },
" \ 'tabline_separator':  { 'left': '', 'right': '' },
" \ 'separator': { 'left': '▓░', 'right': '░▓' },
" \ 'subseparator': { 'left': '|', 'right': '|' },
" \ 'tabline_subseparator': { 'left': '', 'right': '' },
" \ 'tabline_separator':  { 'left': '▓░', 'right': '░▓' },

let g:lightline.active = {
    \ 'left': [ [ 'mode', 'paste' ], [ 'filename' ] ],
    \ 'right': [
    \     [ 'lineinfo' ],
    \     [ 'fileformat', 'fileencoding', 'filetype' ],
    \     [ 'linter_infos', 'linter_warnings', 'linter_errors', 'linter_checking' ],
    \     [ 'codeium', ],
    \ ]
    \ }
    " \     [ 'codeium', 'breadcrumbs' ],

" \ 'left': [ [ 'filename' ] ],
" \ 'right': []
let g:lightline.inactive = {
    \ 'left': [ [ 'filename' ] ],
    \ 'right': [
    \     [ 'lineinfo' ],
    \     [ 'fileformat', 'fileencoding', 'filetype' ],
    \ ]
    \ }

let g:lightline.component = {
    \ 'lineinfo': '%3l:%-2v / %L',
    \ 'maxlines': '%L',
    \ }

" if g:config_use_nvimlsp
"     let g:lightline.component.breadcrumbs = '%{luaeval("require(\"lspsaga.symbol.winbar\").get_bar()")}'
" elseif g:config_use_coc
"     let g:lightline.component.breadcrumbs = '%{%get(b:, "coc_symbol_line", "")%}'
"     " '%{get(b:,"coc_current_function","")}'
" endif

let g:lightline.component_expand = {
    \ 'linter_infos': 'LightlineDiagnosticsInfo',
    \ 'linter_warnings': 'LightlineDiagnosticsWarning',
    \ 'linter_errors': 'LightlineDiagnosticsError',
    \ 'linter_checking': 'LightlineDiagnosticsChecking',
    \ }

let g:lightline.component_function = {
    \ 'fugitive': 'LightLineFugitive',
    \ 'filename': 'LightLineFilename',
    \ 'fileformat': 'LightLineFileFormat',
    \ 'fileencoding': 'LightLineFileEnc',
    \ 'filetype': 'LightLineFileType',
    \ 'customlineinfo': 'LightLineLineInfo',
    \ 'codeium': 'CodeiumStatus',
    \ }

let g:lightline.component_visible_condition = {
    \ }

let g:lightline.component_type = {
    \ 'linter_infos': 'info',
    \ 'linter_warnings': 'warning',
    \ 'linter_errors': 'error',
    \ 'linter_checking': 'info',
    \ }

" \ 'linter_checking': 'info',
" \ 'linter_ok': 'info',
" lightline }}}


" lightline functions {{{

function! CodeiumStatus()
    if !g:config_use_codeium
        return ''
    endif

    let str = codeium#GetStatusString()
    if str ==# ' ON' || str ==# '   '
        return ''
    else
        return '{…} ' . codeium#GetStatusString()
    endif
endfunction

function! LightLineLineInfo()
    return col('.') . ':' . line('.') . '/' . line('$')
endfunction

function! LightLineFileFormat()
    if &fileformat !=# 'unix'
        return winwidth(0) > 85 ? &fileformat : ''
    endif
    return ''
endfunction

function! LightLineFileEnc()
    " return winwidth(0) > 80 ? strlen(&fileencoding) ? &fileencoding : &encoding : ''
    if &fileencoding !=# 'utf-8'
        return strlen(&fileencoding) ? &fileencoding : &encoding
    endif
    return ''
endfunction

function! LightLineFileType()
    " return !strlen(SyntasticStatuslineFlag()) && winwidth(0) > 80 ? strlen(&filetype) ? &filetype : 'unknown' : ''
    return winwidth(0) > 80 ? strlen(&filetype) ? &filetype : 'unknown' : ''
endfunction

function! LightLineFilename()
    " return (expand('%:t') != '' ? expand('%:t') : '[No Name]') .
    return (expand('%') !=# '' ? expand('%') : '[No Name]') .
        \ (&modified !=# '' ? '[+]' : '') .
        \ (&readonly !=# '' ? ' ⭤' : '')
endfunction

function! LightLineFugitive()
    if exists('*fugitive#head') && strlen(fugitive#head())
        return '⎇  '.fugitive#head()
    endif
    return ''
endfunction


function! LightlineUpdateDiagnostics()
    let l:info = { 'error': 0, 'warning': 0, 'info': 0, 'checking': 0 }

    " coc
    if g:config_use_coc
        let l:cocinfo = get(b:, 'coc_diagnostic_info', {})
        if !empty(cocinfo)
            let l:info.error   += get(cocinfo, 'error', 0)
            let l:info.warning += get(cocinfo, 'warning', 0)
            let l:info.info    += get(cocinfo, 'information', 0) + get(cocinfo, 'hint', 0)
        endif

        " ale
        if get(g:, 'ale_enabled', 0) == 1
            let l:aleinfo = ale#statusline#Count(bufnr(''))
            let l:info.error   += get(aleinfo, 'error', 0)   + get(aleinfo, 'style_error', 0)
            let l:info.warning += get(aleinfo, 'warning', 0) + get(aleinfo, 'style_warning', 0)
            let l:info.info    += get(aleinfo, 'info', 0)
            let l:info.checking = ale#engine#IsCheckingBuffer(bufnr(''))
        endif
    endif

    if g:config_use_nvimlsp
        " ALE passes its diagnostics to the internal LSP, so we can just query vim diagnostics
        let l:diags = luaeval('vim.diagnostic.count(0)')
        let l:info.error   += get(diags, 0, 0)  " vim.diagnostic.severity.ERROR
        let l:info.warning += get(diags, 1, 0)  " vim.diagnostic.severity.WARN
        let l:info.info    += get(diags, 2, 0)  " vim.diagnostic.severity.INFO
    endif

    " store in buffer variable
    let b:_lightline_diagnostic_info = l:info
    call lightline#update()
endfun

if g:config_use_coc
    augroup lightline_diagnostics
        autocmd!
        autocmd User ALEJobStarted call LightlineUpdateDiagnostics()
        autocmd User ALELintPost call LightlineUpdateDiagnostics()
        autocmd User ALEFixPost call LightlineUpdateDiagnostics()
        autocmd User CocDiagnosticChange call LightlineUpdateDiagnostics()
        autocmd InsertLeave * call LightlineUpdateDiagnostics()
    augroup END
elseif g:config_use_nvimlsp
    augroup lightline_diagnostics
        autocmd!
        autocmd DiagnosticChanged * call LightlineUpdateDiagnostics()
        " autocmd User LspDiagnosticsChanged call LightlineUpdateDiagnostics()
        " autocmd InsertLeave * call LightlineUpdateDiagnostics()
    augroup END
endif

function! LightlineGetDiagnosticsRaw(name)
    if !exists('b:_lightline_diagnostic_info')
        return 0
    endif
    return get(b:_lightline_diagnostic_info, a:name, 0)
endfun

function! LightlineGetDiagnostics(name)
    let l:count = LightlineGetDiagnosticsRaw(a:name)
    return l:count == 0 ? '' : get(s:diagnostic_symbols, a:name, '') .  string(l:count)
endfun

function! LightlineDiagnosticsError()
    return LightlineGetDiagnostics('error')
endfun

function! LightlineDiagnosticsWarning()
    return LightlineGetDiagnostics('warning')
endfun

function! LightlineDiagnosticsInfo()
    return LightlineGetDiagnostics('info')
endfun

function! LightlineDiagnosticsChecking()
    return LightlineGetDiagnosticsRaw('checking') == 0 ? '' : 'Checking...'
endfun

" lightline functions }}}
