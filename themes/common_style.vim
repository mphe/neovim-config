if has('nvim')
    set termguicolors
endif

if has('win32')
    " for wezterm undercurl support
    let &t_Cs = "\e[4:3m"
    let &t_Ce = "\e[4:0m"
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

    augroup CommonSyntaxFixes
        autocmd!
        autocmd FileType c,cpp call s:CSyntaxFixes()
        autocmd FileType scala call s:ScalaSyntaxFixes()
    augroup END

    " Neovim 0.11 seems to inverse the status/tab line styles which causes inverted lightline rendering
    highlight StatusLine gui=NONE
    highlight StatusLineNC gui=NONE
    highlight StatusLineTerm gui=NONE
    highlight StatusLineTermNC gui=NONE
    highlight TabLine gui=NONE
    highlight TabLineFill gui=NONE

    " blink
    hi clear BlinkCmpCursorLineDocumentationHack
    hi clear BlinkCmpCursorLineSignatureHack
    hi clear BlinkCmpCursorLineMenuHack

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

    " Lspsaga fixes
    hi! link SagaClass Type
    hi! link SagaNamespace @namespace
    hi! link SagaFolder Normal  " Make Lspsaga's breadcrumb folder not red
    " hi! link SagaFolder Type

    " treesitter fixes {{{
    hi! link @keyword.storage @keyword
    hi! link @comment Comment
    " hi! link @property @variable
    hi! link @constant Constant
    hi! link @namespace @module
    hi! link @type.qualifier Keyword

    " python
    " hi! link @lsp.mod.readonly.python Constant
    " hi! link @lsp.typemod.variable.readonly.python Constant

    " gdscript
    hi! link @attribute.gdscript Keyword
    hi! link @string.special.url.gdscript Macro  " $ or % node paths
    " }}}
endfun

" https://vi.stackexchange.com/questions/16813/avoid-highlighting-defined-by-matchadd-in-comments
function! s:CSyntaxFixes()
    hi link doxygenBrief Comment
    hi link doxygenStart doxygenBrief
    hi link doxygenComment doxygenBrief
    hi link doxygenContinueComment doxygenBrief
endfun

function! s:ScalaSyntaxFixes()
    highlight! link scalaSquareBracketsBrackets Normal
    highlight! link scalaInstanceDeclaration Type
    highlight! link scalaCapitalWord Type
    highlight! link scalaCapitalWord Function
    highlight! link scalaKeywordModifier Keyword
    highlight! CocErrorLine ctermbg=NONE guibg=NONE
    highlight! ALEWarning cterm=NONE gui=NONE

    " Add this line at the start of the python syntax file
    syn match scalaFunctionCall "\zs\(\k\w*\)*\s*\ze("
    highlight link scalaFunctionCall Function
endfun
