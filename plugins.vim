let s:vim_cfg_path = fnamemodify($MYVIMRC, ':p:h')

call plug#begin(s:vim_cfg_path . '/plugged')

" Required by: telescope, copilot, codeium.nvim, neo-tree, cmake-tools.nvim
Plug 'nvim-lua/plenary.nvim'

" color schemes
Plug 'ishan9299/nvim-solarized-lua' " Has treesitter support
Plug 'folke/tokyonight.nvim'

Plug 'MunifTanjim/nui.nvim'  " dependency of neo-tree
Plug 'nvim-neo-tree/neo-tree.nvim'

if g:config_use_lightline
    Plug 'itchyny/lightline.vim'
else
    Plug 'nvim-lualine/lualine.nvim'
endif

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
" Plug 'tpope/vim-sleuth'  " Auto detect indent
Plug 'tomtom/tcomment_vim'

if g:config_use_coc
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif

if g:config_use_nvimlsp
    Plug 'mason-org/mason.nvim'
    Plug 'mason-org/mason-lspconfig.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'p00f/clangd_extensions.nvim'
    Plug 'nvimdev/lspsaga.nvim'
    Plug 'seblyng/nvim-echo-diagnostics'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " Needed for hover highlighting
    Plug 'antosha417/nvim-lsp-file-operations'
    Plug 'chrisgrieser/nvim-lsp-endhints'
    Plug 'xzbdmw/colorful-menu.nvim'
    Plug 'barreiroleo/ltex_extra.nvim'
    " Plug 'r0nsha/qfpreview.nvim'  " displays a preview popup for quickfix and loc list
    Plug 'VidocqH/lsp-lens.nvim'
    Plug 'Fildo7525/pretty_hover'
    Plug 'rmagatti/goto-preview'

    " Autocompletion
    Plug 'Saghen/blink.cmp', { 'tag': 'v1.*' }
    " Plug 'Saghen/blink.compat'
    " Plug 'quangnguyen30192/cmp-nvim-ultisnips'
endif

" Edit the quickfix/location list freely
Plug 'itchyny/vim-qfedit'

Plug 'NMAC427/guess-indent.nvim'
Plug 'Raimondi/delimitMate'
Plug 'airblade/vim-gitgutter'
Plug 'jeetsukumaran/vim-buffergator', { 'on': 'BuffergatorOpen' }
Plug 'majutsushi/tagbar', { 'on': 'TagbarOpen' }
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'kien/ctrlp.vim'
Plug 'kshenoy/vim-signature'
Plug 'dense-analysis/ale'
" Plug 'Shougo/vimproc.vim' " TODO: Is this obsolete?
Plug 'dhruvasagar/vim-table-mode'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-user'
Plug 'gaving/vim-textobj-argument'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'junegunn/vim-easy-align'
Plug 'osyo-manga/vim-over'
Plug 'farmergreg/vim-lastplace'
Plug 'romainl/vim-cool'  " improved hlsearch
Plug 'dominikduda/vim_current_word'
Plug 'lambdalisue/suda.vim'
Plug 'embear/vim-localvimrc'
Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-EnhancedJumps'
Plug 'MattesGroeger/vim-bookmarks'

" Scrollbar with diagnostics and search markers
if g:config_use_scrollbar
    Plug 'petertriho/nvim-scrollbar'
endif

" Move function arguments (and other delimited-by-something items) left and right.
Plug 'AndrewRadev/sideways.vim'

" Easy text exchange operator
Plug 'tommcdo/vim-exchange'

" Preview colours in source code while editing
" Plug 'ap/vim-css-color'

Plug 'rcarriga/nvim-notify'

" Required by barbar.nvim, dashboard-nvim and lsp stuff, neo-tree
Plug 'kyazdani42/nvim-web-devicons'

Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }

" Fix CursorHold performance
" FIXME: Maybe remove, apparently not needed anymore
" Plug 'antoinemadec/FixCursorHold.nvim'

" Buffer bar
Plug 'romgrk/barbar.nvim'

" Easy custom highlight patterns
Plug 'folke/paint.nvim'

Plug 'sakhnik/nvim-gdb'

if g:config_use_copilot
    " Plug 'github/copilot.vim'
    " Plug 'samodostal/copilot-client.lua'
    Plug 'zbirenbaum/copilot.lua'
elseif g:config_use_codeium
    Plug 'Exafunction/codeium.vim', { 'branch': 'main' }
endif

if g:config_use_dashboard
    " Startup screen
    " Plug 'mhinz/vim-startify'

    " Startup screen
    " Requires nvim-web-devicons
    Plug 'nvimdev/dashboard-nvim'
endif

if g:use_vim_omnisharp
    Plug 'OmniSharp/omnisharp-vim'
    Plug 'Shougo/echodoc.vim'
endif

" filetype stuff {{{
Plug 'vimperator/vimperator.vim'
Plug 'neoclide/jsonc.vim'
Plug 'mphe/vim-gdscript4'
Plug 'withgod/vim-sourcepawn'

Plug 'derekwyatt/vim-fswitch', { 'for': ['c', 'cpp'] }
Plug 'derekwyatt/vim-protodef', { 'for': ['c', 'cpp'] }
Plug 'tmhedberg/SimpylFold', { 'for': ['python', 'gdscript'] }
Plug 'Vimjas/vim-python-pep8-indent', { 'for': ['python', 'gdscript'] }
Plug 'vim-python/python-syntax', { 'for': ['python'] }

Plug 'lervag/vimtex', { 'for': 'tex' }

" If you don't have nodejs and yarn
" use pre build, add 'vim-plug' to the filetype list so vim-plug can update this plugin
" see: https://github.com/iamcco/markdown-preview.nvim/issues/50
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
" If you have nodejs
" Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }

Plug 'tpope/vim-liquid', { 'for': 'liquid' }  " jekyll

" Plug 'mingchaoyan/vim-shaderlab'
Plug 'tikhomirov/vim-glsl', { 'for': 'glsl' }

Plug 'captbaritone/better-indent-support-for-php-with-html', { 'for': 'php' }
" Plug 'mattn/emmet-vim'  " Disabled because it adds keybindings with <c-y> prefix

" should be unnecessary because vim and neovim have qml support integrated now, but for some reason it doesn't work for me
Plug 'peterhoeg/vim-qml', { 'for': 'qml' }

Plug 'weirongxu/plantuml-previewer.vim', { 'for': 'plantuml' }
Plug 'mzlogin/vim-markdown-toc', { 'for': 'markdown' }  " Generate TOC in markdown files
Plug 'JafarDakhan/vim-gml', { 'for': 'gml' }
Plug 'shiracamus/vim-syntax-x86-objdump-d'
Plug 's3rvac/vim-syntax-jira'

" Interact with jupyter from neovim
Plug 'benlubas/molten-nvim', { 'do': ':UpdateRemotePlugins', 'for': 'python' }

" }}}


call plug#end()
