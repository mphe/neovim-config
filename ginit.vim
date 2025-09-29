if exists('g:ginit_vim_loaded')
    finish
endif
let g:ginit_vim_loaded = 1


" Default font settings
let s:guifont = 'Terminus'
let s:guifontwide = 'Symbols\ Nerd\ Font'
let s:guifontsize = 9

if has('win32')
    let s:guifont = 'Terminus\ (TTF)\ for\ Windows'
endif


function! ChangeFontSize(delta)
    let s:guifontsize = s:guifontsize + a:delta
    exec 'set guifont=' . s:guifont . ':h' . s:guifontsize
    exec 'set guifontwide=' . s:guifontwide . ':h' . s:guifontsize
endfunction

nnoremap <expr><C-+> ChangeFontSize(1)
nnoremap <expr><C--> ChangeFontSize(-1)

if exists('g:neovide')
    let g:neovide_cursor_animation_length = 0
    let g:neovide_cursor_trail_size = 0
    let g:neovide_cursor_animate_in_insert_mode = v:false
    let g:neovide_cursor_animate_command_line = v:false
    let g:neovide_scroll_animation_length = 0.1
    let g:neovide_cursor_vfx_mode = ''
    let g:neovide_scale_factor=1.0
    let g:neovide_padding_top = 0
    let g:neovide_padding_bottom = 0
    let g:neovide_padding_right = 0
    let g:neovide_padding_left = 0
    let g:neovide_title_background_color = '#002b36'
    let g:neovide_title_text_color = '#93a1a1'
    let g:neovide_hide_mouse_when_typing = v:true
    let g:neovide_confirm_quit = v:false
    let g:neovide_remember_window_size = v:true
    let g:neovide_cursor_antialiasing = v:false

    let g:neovide_floating_shadow = v:true
    let g:neovide_floating_z_height = 10
    let g:neovide_light_angle_degrees = 45
    let g:neovide_light_radius = 5
    let g:neovide_floating_corner_radius = 0.5

    " turn off all animations
    let g:neovide_position_animation_length = 0
    let g:neovide_cursor_animation_length = 0.00
    let g:neovide_cursor_trail_size = 0
    let g:neovide_cursor_animate_in_insert_mode = v:false
    let g:neovide_cursor_animate_command_line = v:false
    let g:neovide_scroll_animation_far_lines = 0
    let g:neovide_scroll_animation_length = 0.00

    " Use Nerd Font because Bitmap fonts are not supported and disable AA
    " let s:guifont = 'Terminus_(TTF)'
    " let s:guifont = 'Terminess_Nerd_Font:#e-alias'
    let s:guifont = 'Terminus_(TTF)_for_Windows,Symbols_Nerd_Font'
    set linespace=-2

    " Control + shift + c/v for copy & paste
    lua vim.api.nvim_set_keymap("v", "<sc-c>", '"+y', { noremap = true })
    lua vim.api.nvim_set_keymap('v', '<sc-v>', '"+P', { noremap = true })
    lua vim.api.nvim_set_keymap("i", "<sc-v>", '<ESC>"+p', { noremap = true })
    lua vim.api.nvim_set_keymap("n", "<sc-v>", '"+p', { noremap = true })
    lua vim.api.nvim_set_keymap("c", "<sc-v>", "<C-R>+", { noremap = true })
endif


if exists('g:fvim_loaded')
    FVimCustomTitleBar v:true
    FVimKeyAltGr v:true
    " FVimUIPopupMenu v:false
    " FVimUIWildMenu v:false

    nnoremap <silent><C-ScrollWheelUp> :set guifont=+<CR>
    nnoremap <silent><C-ScrollWheelDown> :set guifont=-<CR>
    nnoremap <silent> <C-+> :set guifont=+<CR>
    nnoremap <silent> <C--> :set guifont=-<CR>
    nnoremap <A-CR> :FVimToggleFullScreen<CR>

    let s:guifontsize = 12

endif


" Apply font defaults
call ChangeFontSize(0)
