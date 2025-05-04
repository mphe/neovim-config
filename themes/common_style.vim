if has('nvim')
    set termguicolors
endif

let s:transparent_background = 0

function ApplyCommonStylePre()
    augroup AutocmdCommonStylesPre
        autocmd!
        autocmd VimEnter * call s:EarlyStyleOverrides()
        autocmd ColorScheme * call s:EarlyStyleOverrides()
    augroup END

    call s:EarlyStyleOverrides()
endfun

function! s:EarlyStyleOverrides()
    highlight link cppStorageClass Keyword
    " highlight link cTypedef Keyword
endfun

function ApplyCommonStyle()
    if s:transparent_background
        highlight Normal     ctermbg=NONE guibg=NONE
    endif

    " Neovim 0.11 seems to inverse the status/tab line styles which causes inverted lightline rendering
    highlight StatusLine gui=NONE
    highlight StatusLineNC gui=NONE
    highlight TabLine gui=NONE
    highlight TabLineFill gui=NONE

    " vimSet has no highlight for some reason in nvim 0.11
    hi! link vimSet vimCommand

    highlight! link QuickFixLine CursorLine

    " telescope
    hi! link TelescopeSelection Pmenu

    " make comments non-italic
    highlight Comment cterm=NONE gui=NONE

    " No underline in folds
    highlight Folded cterm=bold gui=bold

    " Add this line at the start of the python syntax file
    " syn match pythonFunctionCall "\zs\(\k\w*\)*\s*\ze("
    highlight link pythonFunctionCall Function

    " Prevent LSP semantic tokens overriding custom highlights
    hi clear @lsp.type.variable

    " treesitter fixes {{{
    hi! link @keyword.storage @keyword
    hi! link @comment Comment
    " hi! link @property @variable
    hi! link @constant Constant

    " python
    " hi! link @lsp.mod.readonly.python Constant
    " hi! link @lsp.typemod.variable.readonly.python Constant

    " gdscript
    hi! link @attribute.gdscript Keyword
    hi! link @string.special.url.gdscript Macro  " $ or % node paths
    " }}}
endfun
