" File monitoring with :checktime
command! Monitor call s:MonitorStart()
command! MonitorOff call s:MonitorStop()

function! s:MonitorCheck(bufnr, timer) abort
    let l:winid = bufwinid(a:bufnr)
    let l:at_end = l:winid != -1 && getbufinfo(a:bufnr)[0].linecount == line('.', l:winid)
    execute 'checktime ' . a:bufnr
    if l:at_end && l:winid != -1
        call win_execute(l:winid, 'normal! G')
    endif
endfunction

function! s:MonitorStart() abort
    let l:bufnr = bufnr('%')
    call s:MonitorStopBuf(l:bufnr)
    let l:timer = timer_start(100, function('s:MonitorCheck', [l:bufnr]), {'repeat': -1})
    call setbufvar(l:bufnr, '_monitor_timer', l:timer)
endfunction

function! s:MonitorStop() abort
    call s:MonitorStopBuf(bufnr('%'))
endfunction

function! s:MonitorStopBuf(bufnr) abort
    let l:timer = getbufvar(a:bufnr, '_monitor_timer', -1)
    if l:timer != -1
        call timer_stop(l:timer)
        call setbufvar(a:bufnr, '_monitor_timer', -1)
    endif
endfunction
