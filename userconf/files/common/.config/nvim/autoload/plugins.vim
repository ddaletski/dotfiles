call plug#begin('~/.vim/plugged')

Plug 'ryanoasis/vim-devicons'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'terryma/vim-multiple-cursors'
Plug 'alvan/vim-closetag'
Plug 'shougo/echodoc'
Plug 'preservim/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'jeetsukumaran/vim-buffergator'

" color scheme
Plug 'morhetz/gruvbox'

" fuzzy searcher
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" shortcuts helper
Plug 'liuchengxu/vim-which-key'

call plug#end()

" coc extensions
let g:coc_global_extensions = ['coc-highlight', 'coc-python', 'coc-rust-analyzer', 'coc-vimlsp']

let g:NERDCreateDefaultMappings = 0
let g:buffergator_suppress_keymaps = 1
