call plug#begin('~/.vim/plugged')

" vim popup api support
Plug 'kamykn/popup-menu.nvim'

Plug 'kyazdani42/nvim-web-devicons'
Plug 'neoclide/coc.nvim', {'branch' : 'release'}
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'alvan/vim-closetag'
Plug 'shougo/echodoc'
Plug 'preservim/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'voldikss/vim-floaterm'
Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }
Plug 'vimwiki/vimwiki'
Plug 'puremourning/vimspector'
Plug 'tikhomirov/vim-glsl'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
Plug 'gauteh/vim-cppman'
Plug 'rhysd/rust-doc.vim'
Plug 'slint-ui/vim-slint'
Plug 'editorconfig/editorconfig-vim'
Plug 'phaazon/hop.nvim'

" color schemes
Plug 'noahfrederick/vim-hemisu'
Plug 'preservim/vim-colors-pencil'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'humanoid-colors/vim-humanoid-colorscheme'


" telescope
Plug 'nvim-lua/plenary.nvim' " fuzzy searcher used by telescope
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'

" shortcuts helper
Plug 'folke/which-key.nvim'

" focus mode
Plug 'junegunn/goyo.vim'

call plug#end()

" coc extensions
let g:coc_global_extensions = [
            \ 'coc-highlight',
            \ 'coc-pyright',
            \ 'coc-rust-analyzer',
            \ 'coc-vimlsp',
            \ 'coc-sumneko-lua',
            \ 'coc-cmake',
            \ 'coc-json',
            \ 'coc-sh',
            \ 'coc-markdownlint',
            \ 'coc-toml'
            \ ]

let g:NERDCreateDefaultMappings = 0 "disable default keys for NERDCommenter
let g:rust_doc#define_map_K = 0 " disable default keys for rust-doc

lua require('hop').setup { keys = 'etovxqpdygfblzhckisuran' }


" load init files for plugins
for file in ['telescope_init', 'bufferline_init', 'which_key_init']
    let fpath = $HOME . '/.config/nvim/lua/' . file .'.lua'
    exe 'source' fpath
endfor
