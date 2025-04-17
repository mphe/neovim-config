if exists('did_cpp_vim')
    finish
endif
let did_cpp_vim = 1

" Don't indent function after template declaration
function! CppNoTemplateIndent()
    let l:cline_num = line('.')
    let pline_num = prevnonblank(cline_num - 1)
    let pline = getline(pline_num)
    let cline = getline(cline_num)

    " Treat comments as empty space when looking for a previous line.
    " Only worry about C++-style comments.
    while pline =~ '^\s*//'
        let pline_num = prevnonblank(pline_num - 1)
        let pline = getline(pline_num)
    endwhile

    if pline =~# '^\s*template.*'
        return cindent(pline_num)
    else
        return cindent(cline_num)
    endif
endfunction

setlocal indentexpr=CppNoTemplateIndent()
