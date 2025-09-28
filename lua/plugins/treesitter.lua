local use_treesitter = true
local use_treesitter_fold = false
local enabled_highlights = {
    markdown = true,
    markdown_inline = true,
    -- gdscript = true,
    -- gdshader = true,
}

if use_treesitter_fold then
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
end

require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = {
        "markdown",
        "markdown_inline",
        "c",
        "cpp",
        "gdscript",
        -- "gdshader",
        "go",
        "python",
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = false,

    -- List of parsers to ignore installing (or "all")
    -- ignore_install = { "javascript" },

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    indent = {
        enable = false
    },
    highlight = {
        enable = use_treesitter,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        -- disable = { "c", "rust" },
        disable = function(lang, _buf)
            return enabled_highlights[lang] ~= true

            -- Disable slow treesitter highlight for large files
            -- local max_filesize = 100 * 1024 -- 100 KB
            -- local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            -- if ok and stats and stats.size > max_filesize then
            --     return true
            -- end
        end,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = {},
    },
}

require("nvim-treesitter.install").prefer_git = true
