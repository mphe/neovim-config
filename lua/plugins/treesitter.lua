local use_treesitter_fold = false
local use_treesitter_indent = false

vim.api.nvim_create_autocmd('FileType', {
    pattern = {
        "markdown",
        "markdown_inline",
        "vimdoc",
        "copilot-chat",
        "qml",
    },
    callback = function(ev)
        -- syntax highlighting, provided by Neovim
        vim.treesitter.start()

        -- folds, provided by Neovim
        if use_treesitter_fold then
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.wo.foldmethod = 'expr'
        end

        -- indentation, provided by nvim-treesitter
        if use_treesitter_indent then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end

        -- Keep normal syntax highlighting because sometimes they complement each other
        vim.bo[ev.buf].syntax = 'ON'
    end,
})
