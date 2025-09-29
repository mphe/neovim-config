if exists('g:restart_vim_loaded')
    finish
endif
let g:restart_vim_loaded = 1


let g:restart_vim_session_file = '.lastsession.vim'

augroup au_restart_vim
    au!
    " kinda fix tagbar cursor lag
    autocmd VimEnter * call s:maybe_restore()
augroup END


function s:maybe_restore()
    if filereadable(g:restart_vim_session_file)
        exec 'source ' . g:restart_vim_session_file
        call delete(g:restart_vim_session_file)
    endif
endfun


function s:save_session()
    exec 'mksession! ' . g:restart_vim_session_file
endfun


function s:restart()
    call s:save_session()
    qall
endfun


command! SaveSession call s:restart()
command! Restart call s:restart()
command! Restore call s:maybe_restore()
