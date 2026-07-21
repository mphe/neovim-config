" Adds 'c' as vim-surround command to wrap selection in a latex command like \emph{}
let b:surround_{char2nr('c')} = "\\\1command\1{\r}"
