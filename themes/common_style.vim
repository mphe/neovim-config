let s:transparent_background = 0

augroup custom_colors
    autocmd!
    autocmd ColorSchemePre * call s:ApplyStylePre()
    autocmd ColorScheme * call s:ApplyStyle()
augroup END

function! s:ApplyStylePre()
endfun

function s:ApplyStyle()
    if s:transparent_background
        highlight Normal ctermbg=NONE guibg=NONE
    endif

    " Internal styles
    hi! link QuickFixLine CursorLine
    highlight Comment cterm=NONE gui=NONE  " make comments non-italic
    highlight Folded cterm=bold gui=bold  " No underline in folds
    highlight CursorLine cterm=NONE gui=NONE  " Strip modifiers like underline

    hi! link SignColumn LineNr
    hi! link WinSeparator LineNr

    highlight DiagnosticUnderlineWarn gui=undercurl
    highlight DiagnosticUnderlineHint gui=undercurl
    highlight DiagnosticUnderlineInfo gui=undercurl
    highlight DiagnosticUnderlineOk gui=undercurl
    highlight DiagnosticUnderlineError gui=undercurl

    hi! link qfError DiagnosticError

    " Language style fixes
    hi! link vimSet vimCommand  " vimSet has no highlight for some reason in nvim 0.11
    hi! link cStorageClass cStatement  " const
    hi! link cppStorageClass cStorageClass
    hi! link cStructure cStatement  " class, struct, namespace, ...
    hi! link cppStructure cStructure
    hi! link cModifier cStatement  " inline, ...
    hi! link cppModifier cModifier
    hi! link cppOperator Function  " Operator overloads; makes it more readable in class declarations

    " TODO: find out if still needed
    " call s:ScalaSyntaxFixes()


    " treesitter / lsp fixes {{{
    hi! link @keyword.storage @keyword
    hi! link @comment Comment
    " hi! link @property @variable
    hi! link @constant Constant
    hi! link @namespace @module
    hi! link @type.qualifier Keyword
    hi! link @markup.raw.markdown_inline markdownCode
    " hi! link @markup.raw.block.markdown markdownCodeDelimiter
    hi! link @markup.quote.markdown markdownBlockquote
    hi! link @markup.list markdownListMarker
    hi! link @markup.link.url markdownUrl

    " Prevent LSP semantic tokens overriding custom highlights
    hi @lsp.type.variable guifg=NONE guibg=NONE

    " python
    hi link @lsp.typemod.variable.readonly.python Constant

    " gdscript
    hi! link @attribute.gdscript Keyword
    hi! link @string.special.url.gdscript Macro  " $ or % node paths

    " rust
    hi link @lsp.type.const.rust Constant
    hi link @lsp.type.typeAlias.rust Type
    " }}}

    " Plugin styles
    " telescope
    hi! link TelescopeSelection Pmenu

    " Lspsaga
    hi! link SagaActionTitle Title
    hi! link SagaClass Type
    hi! link SagaNamespace @namespace
    hi! link SagaFolder Normal  " Make Lspsaga's breadcrumb folder not red

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
