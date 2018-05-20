call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-easy-align'
Plug 'https://github.com/junegunn/vim-github-dashboard.git'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

Plug 'terryma/vim-multiple-cursors'

Plug 'roxma/nvim-completion-manager'
Plug 'roxma/ncm-clang'
Plug 'roxma/nvim-cm-tern',  {'do': 'npm install'}

Plug 'mattn/emmet-vim'
Plug 'alvan/vim-closetag'

Plug 'vim-syntastic/syntastic'
Plug 'vim-scripts/indentpython.vim'

Plug 'flazz/vim-colorschemes'
Plug 'mhartington/oceanic-next'

Plug 'Shougo/denite.nvim'
Plug 'sandeepcr529/Buffet.vim'

Plug 'lervag/vimtex'

"Initialize plugin system
call plug#end()

set foldmethod=indent
set foldlevel=99
set colorcolumn=100

py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    activate_this = os.path.join(project_base_dir,
    'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF


" Theme
let python_highlight_all=1

syntax enable
set  t_Co=256
set bg=dark
colorscheme OceanicNext

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

tnoremap <Esc> <C-\><C-n>

" buffet
nnoremap <Tab> :Bufferlist<CR>

filetype off
filetype plugin indent on
set smartindent
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4


" multi cursor
let g:multi_cursor_exit_from_visual_mode=0
let g:multi_cursor_exit_from_insert_mode=0