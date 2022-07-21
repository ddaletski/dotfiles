call plug#begin('~/.vim/plugged')

Plug 'kyazdani42/nvim-web-devicons'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
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

" color schemes
Plug 'morhetz/gruvbox'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'altercation/vim-colors-solarized'
Plug 'rakr/vim-one'
Plug 'rmehri01/onenord.nvim', { 'branch': 'main' }

" telescope
Plug 'nvim-lua/plenary.nvim' " fuzzy searcher used by telescope
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'

" shortcuts helper
Plug 'folke/which-key.nvim'

call plug#end()

" coc extensions
let g:coc_global_extensions = [
            \ 'coc-highlight',
            \ 'coc-python',
            \ 'coc-rust-analyzer',
            \ 'coc-vimlsp',
            \ 'coc-sumneko-lua',
            \ 'coc-cmake',
            \ 'coc-json',
            \ 'coc-sh'
            \ ]

let g:NERDCreateDefaultMappings = 0 "disable default keys for NERDCommenter

" load init files for plugins
for file in ['telescope_init', 'bufferline_init', 'which_key_init']
    let fpath = $HOME . '/.config/nvim/lua/' . file .'.lua'
    exe 'source' fpath
endfor
