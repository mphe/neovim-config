syn match pyClass "\v<\u\w+>"
syn match pyConstant  "\v<[A-Z_]+[A-Z0-9_]*>"
" syn match pythonFunctionCall "\zs\(\k\w*\)*\s*\ze("

hi def link pyClass Type
hi def link pyConstant Constant
" hi def link pythonFunctionCall Function
