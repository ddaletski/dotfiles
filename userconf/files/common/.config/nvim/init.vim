filetype indent off
filetype plugin on
filetype plugin indent on
syntax on
set nocompatible

" load vim config files
for file in ['plugins', 'themes', 'keys']
    let fpath = $HOME . '/.config/nvim/autoload/' . file . '.vim'
    exe 'source' fpath
endfor

" Theme
" available options for themes switcher
" use '<scheme>|dark'/'<scheme>|light' format if only one bg style is
" needed. E.g. 'onehalfdark|dark'
let g:themes_options = ['gruvbox', 'onenord', 'one']
colorscheme one
set background=dark
let g:airline_theme='one' " TODO: add hook to themes switcher
let g:airline#extensions#tabline#enabled = 1
let python_highlight_all=1

" turn absolute line numbers on
set number
set nu

set smartindent
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set smartcase

set completeopt=noinsert,menuone,noselect

set foldmethod=indent
set foldlevel=99
set colorcolumn=100

" live substitution
:set inccommand=split

" multi cursor
let g:multi_cursor_exit_from_visual_mode=0
let g:multi_cursor_exit_from_insert_mode=0

" buffergator
let g:buffergator_viewport_split_policy = "t"
let g:buffergator_autoupdate = 1
let g:buffergator_hsplit_size = 5

""""""""""""""""""""""""""""""""""""""""""""""""""
" COC

" Highlight symbol under cursor on CursorHold and show signature on CursorHoldI
set updatetime=300
"autocmd CursorHoldI * silent call CocActionAsync('showSignatureHelp')
autocmd CursorHold * silent call CocActionAsync('highlight')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

"""""""""""""""""""""""""""""""""""""""""""""""""""
" echodoc

set cmdheight=1
set noshowmode
let g:echodoc#enable_at_startup = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType h,hpp,cpp,cxx set keywordprg=cppman
