" ------------------ General
let s:base03  = '#002b36'
let s:base02  = '#073642'
let s:base01  = '#586e75'
let s:base00  = '#657b83'
let s:base0   = '#839496'
let s:base1   = '#93a1a1'
let s:base2   = '#eee8d5'
let s:base3   = '#fdf6e3'
let s:yellow  = '#b58900'
let s:orange  = '#cb4b16'
let s:red     = '#dc322f'
let s:magenta = '#d33682'
let s:violet  = '#6c71c4'
let s:blue    = '#268bd2'
let s:cyan    = '#2aa198'
let s:green   = '#859900'
let s:blue3   = '#094655'

" custom colors for more variety
let s:blue_light = '#65a5de'

let s:base4   = '#a3b1b1'
let s:pum_fg  = '#C6C6C6'
let s:pum_bg = s:blue3
let s:slight_cyan = '#71A3A0'

" Actually not normal fg and bg but the slightly brighter variant.
" TODO: rename
let s:normal_fg = s:base0
let s:normal_bg = s:base02

augroup custom_solarized_colorscheme
    autocmd!
    autocmd ColorSchemePre solarized call s:ApplySolarizedStylePre()
    autocmd ColorScheme solarized call s:ApplySolarizedStyle()
augroup END

function s:ApplySolarizedStylePre()
    if &background !=? 'dark'
        return
    endif
endfun

function s:ApplySolarizedStyle()
    " Neovim 0.11 seems to inverse the status/tab line styles which causes inverted lightline rendering
    highlight StatusLine gui=NONE
    highlight StatusLineNC gui=NONE
    highlight StatusLineTerm gui=NONE
    highlight StatusLineTermNC gui=NONE
    highlight TabLine gui=NONE
    highlight TabLineFill gui=NONE

    " From here on only dark scheme settings
    if &background !=? 'dark'
        highlight! link CurrentWordTwins Search
        highlight! link CurrentWord CurrentWordTwins
        return
    endif

    call s:ApplySolarizedDark()
endfun


function s:ApplySolarizedDark()
    " Define a second Normal highlight because Normal might have a transparent background.
    exec 'highlight NormalBgFg gui=NONE guibg=' . s:base03 . ' guifg=' . s:base1
    exec 'highlight BrighterBgFg gui=NONE guibg=' . s:base02 . ' guifg=' . s:base4
    exec 'highlight BrightBgFg guibg=' . s:pum_bg . ' guifg=' . s:pum_fg
    exec 'highlight BlueFg guifg=' . s:blue
    exec 'highlight SlightBlueFg guifg=' . s:blue_light
    exec 'highlight VioletFg guifg=' . s:violet
    exec 'highlight MagentaFg guifg=' . s:magenta
    exec 'highlight CyanFg guifg=' . s:cyan
    exec 'highlight SlightCyanFg guifg=' . s:slight_cyan
    exec 'highlight RedFg guifg=' . s:red
    exec 'highlight WhiteFg guifg=' . s:base2

    call s:ApplyBarBar()

    hi! Folded guibg=NONE gui=bold

    hi markdownCode guibg=#223344
    hi link doxygenBrief Comment

    " treesitter / lsp {{{
    hi! link @module VioletFg
    hi! link @property SlightBlueFg
    hi! link @lsp.type.typeParameter WhiteFg  " c++ templates parameters
    " hi! link LspCodeLens Comment
    " hi! link LspInlayHint Comment
    highlight NonText guibg=#073642 guifg=#6C71C4 gui=NONE
    " highlight LspCodeLens guibg=#073642 guifg=#6C71C4
    " highlight! link LspInlayHint LspCodeLens
    " }}}

    " Search highlight color
    highlight Search cterm=NONE ctermbg=240 ctermfg=black gui=NONE guibg=#586e75 guifg=#073642
    highlight! link CurSearch Search
    highlight link EasyMotionMoveHL Search
    highlight CurrentWordTwins ctermbg=black guibg=#094655
    highlight link CurrentWord CurrentWordTwins
    " highlight CursorLineNr cterm=bold ctermfg=3 ctermbg=black gui=bold guifg=#b58900 guibg=#073642

    highlight clear Error
    exec 'highlight Error cterm=undercurl ctermfg=1 gui=undercurl guisp=' . s:red
    highlight link SpellBad Error

    exec 'highlight! DiagnosticError cterm=bold gui=bold guifg=' . s:orange
    exec 'highlight! DiagnosticWarn cterm=bold gui=bold guifg=' . s:yellow
    exec 'highlight! DiagnosticInfo cterm=bold gui=bold guifg=' . s:base1
    highlight! link DiagnosticHint DiagnosticInfo

    hi! link WinBar Normal
    hi! link WinBarNC Normal
    highlight PmenuSbar  ctermfg=12 ctermbg=0
    hi! link Pmenu BrightBgFg
    hi! link FloatBorder BlueFg
    highlight VertSplit  ctermbg=0 guibg=#073642

    " For some reason removed lines in git diffs are not red when not using fugitive.
    hi! link Removed RedFg
    " hi! DiffAdd guifg=NONE guibg=#004e41
    " hi! DiffAdd guifg=NONE guibg=#003626
    " hi! DiffChange guifg=NONE guibg=#363600

    " blink.cmp
    hi! link NormalFloat NormalBgFg
    hi! link BlinkCmpCursorLineMenuHack NormalBgFg
    hi! link BlinkCmpCursorLineSignatureHack NormalBgFg
    hi! link BlinkCmpSignatureHelp NormalBgFg
    hi! link BlinkCmpSignatureHelpBorder FloatBorder
    hi! link BlinkCmpSignatureHelpActiveParameter BrightBgFg
    hi! link BlinkCmpMenu NormalBgFg
    hi! link BlinkCmpMenuSelection BrightBgFg
    hi! link BlinkCmpMenuBorder FloatBorder
    hi! BlinkCmpLabelMatch guifg=NONE guibg=NONE gui=underline

    " Lspsaga
    hi! link SagaLightBulb Type

    " coc
    if g:config_use_coc
        highlight link CocErrorSign   DiagnosticError
        highlight link CocWarningSign DiagnosticWarn
        highlight link CocInfoSign    DiagnosticInfo
        highlight link CocHintSign CocInfoSign
        highlight CocErrorFloat   cterm=NONE ctermbg=black ctermfg=9   gui=NONE guibg=#094655 guifg=#cb4b16
        highlight CocWarningFloat cterm=NONE ctermbg=black ctermfg=130 gui=NONE guibg=#094655 guifg=#b58900
        highlight CocInfoFloat    cterm=NONE ctermbg=black ctermfg=11  gui=NONE guibg=#094655
        highlight link CocHintFloat CocInfoFloat
        " highlight link NormalFloat CursorLine
        highlight link CocFadeOut Comment

        " fix completion menu colors
        " hi link CocMenuSel PmenuSel
        " hi link CocFloating Pmenu
        hi link CocMenuSel BrightBgFg
        hi link CocFloating NormalBgFg
        " hi link CocFloating BrighterBgFg
        exec 'highlight CocFloatingBorder guifg=' . s:blue

        highlight CocUnderline cterm=underline gui=underline
        " highlight CocErrorLine ctermbg=52 guibg=#4F2938
        " highlight link CocErrorHighlight Error
        highlight CocCodeLens guibg=#073642 guifg=#6C71C4
        highlight! link CocInlayHint CocCodeLens

        highlight link CocInlayHintType Comment
        " exec 'highlight CocInlayHintType guifg=' . s:yellow . ' guibg=#333333'
        " exec 'highlight CocInlayHintType guifg=' . s:base01 . ' guibg=' . s:normal_bg
        " exec 'highlight CocInlayHintType guifg=' . s:yellow . ' guibg=' . s:pum_bg
        " exec 'highlight CocInlayHintType guibg=' . s:normal_bg

        " template arguments
        exec 'hi CocSemTypeTypeParameter guifg=' . s:base2
        hi link CocSemType CocSemTypeType
        hi link CocSemTypeClass CocSemTypeType
        hi link CocSemTypeStruct CocSemTypeType
        hi link CocSemTypeEnumMember @constant
        hi link CocSemTypeModVariableReadonly SlightCyanFg
        hi link CocSemTypeModParameterReadonly CocSemTypeModVariableReadonly
        hi link CocSemTypeEvent @property

        " coc-lightbulb
        exec 'hi LightBulbDefaultSign guibg=' . s:normal_bg

        " ale
        highlight! link ALEError CocErrorHighlight
        highlight! link ALEErrorLine CocErrorLine
        highlight! link ALEErrorSign CocErrorSign
        highlight! link ALEWarning CocWarningHighlight
        highlight! link ALEWarningLine CocWarningLine
        highlight! link ALEWarningSign CocWarningSign
        highlight! link ALEInfo CocInfoHighlight
        highlight! link ALEInfoLine CocInfoLine
        highlight! link ALEInfoSign CocInfoSign

        highlight! link ALEVirtualTextError ALEErrorSign
        highlight! link ALEVirtualTextWarning ALEWarningSign
        highlight! link ALEVirtualTextInfo ALEInfoSign
    endif

    highlight fugitiveUnstagedSection ctermfg=red guifg=#dc322f
    highlight link fugitiveUntrackedSection fugitiveUnstagedSection
    highlight fugitiveStagedSection ctermfg=green guifg=#859900

    hi texStatement ctermbg=NONE guibg=NONE
    exec 'highlight VirtColumn guifg=' . s:normal_bg . ' guibg=NONE'

    " tagbar
    hi link TagbarAccessProtected BlueFg
endfun


function s:ApplyBarBar()
    " darker background for active buffers
    " let current_bg = s:normal_bg
    " let current_fg = s:pum_fg
    " let visible_bg = current_bg
    " let visible_fg = s:normal_fg
    " let inactive_bg = s:blue3
    " let inactive_fg = visible_fg
    " let bufferline_bg = s:base03

    " brighter background for active buffers
    let current_bg = s:blue3
    let current_fg = s:pum_fg
    let inactive_bg = s:normal_bg
    let inactive_fg = s:normal_fg
    let visible_bg = inactive_bg
    let visible_fg = current_fg
    let bufferline_bg = s:base03
    let modif_fg = s:red
    let error_fg = s:orange

    exec 'highlight BufferCurrent           guibg=' . current_bg  . ' guifg=' . current_fg
    exec 'highlight BufferCurrentIcon       guibg=' . current_bg  . ' guifg=' . current_fg
    exec 'highlight BufferCurrentMod        guibg=' . current_bg  . ' guifg=' . modif_fg
    exec 'highlight BufferCurrentSign       guibg=' . current_bg  . ' guifg=' . bufferline_bg
    exec 'highlight BufferCurrentERROR      guibg=' . current_bg  . ' guifg=' . error_fg
    exec 'highlight BufferInactive          guibg=' . inactive_bg . ' guifg=' . inactive_fg
    exec 'highlight BufferInactiveSign      guibg=' . inactive_bg . ' guifg=' . bufferline_bg
    exec 'highlight BufferInactiveMod       guibg=' . inactive_bg . ' guifg=' . modif_fg
    exec 'highlight BufferInactiveERROR     guibg=' . inactive_bg  . ' guifg=' . error_fg
    exec 'highlight BufferVisible           guibg=' . visible_bg  . ' guifg=' . visible_fg
    exec 'highlight BufferVisibleSign       guibg=' . visible_bg  . ' guifg=' . bufferline_bg
    exec 'highlight BufferVisibleMod        guibg=' . visible_bg  . ' guifg=' . modif_fg
    exec 'highlight BufferVisibleERROR      guibg=' . visible_bg  . ' guifg=' . error_fg
    exec 'highlight BufferTabpageFill       guibg=' . bufferline_bg . ' guifg=' . bufferline_bg

    " powerline
    exec 'highlight BufferCurrentSignRight  guibg=' . bufferline_bg . ' guifg=' . current_bg
    exec 'highlight BufferInactiveSignRight guibg=' . bufferline_bg . ' guifg=' . inactive_bg
    exec 'highlight BufferVisibleSignRight  guibg=' . bufferline_bg . ' guifg=' . visible_bg

    " slanted
    " exec 'highlight BufferCurrentSignRight  guibg=' . current_bg  . ' guifg=' . bufferline_bg
    " exec 'highlight BufferInactiveSignRight guibg=' . inactive_bg . ' guifg=' . bufferline_bg

    " highlight BufferCurrent
    " highlight BufferCurrentADDED
    " highlight BufferCurrentBtn
    " highlight BufferCurrentCHANGED
    " highlight BufferCurrentDELETED
    " highlight BufferCurrentERROR
    " highlight BufferCurrentHINT
    " highlight BufferCurrentINFO
    " highlight BufferCurrentIcon
    " highlight BufferCurrentIndex
    " highlight BufferCurrentMod
    " highlight BufferCurrentModBtn
    " highlight BufferCurrentNumber
    " highlight BufferCurrentPin
    " highlight BufferCurrentPinBtn
    " highlight BufferCurrentSign
    " highlight BufferCurrentSignRight
    " highlight BufferCurrentTarget
    " highlight BufferCurrentWARN
endfun
