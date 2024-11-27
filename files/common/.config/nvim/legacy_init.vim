filetype indent off
filetype plugin on
filetype plugin indent on
syntax on
set nocompatible
let g:mapleader = "\<Space>"
let g:maplocalleader = ','
set timeoutlen=500

" load vim config files
for file in ['plugins', 'themes', 'keys']
    let lua_init_path = $HOME . '/.config/nvim/autoload/' . file . '.vim'
    exe 'source' lua_init_path
endfor

" Theme
" available options for themes switcher
" use '<scheme>|dark'/'<scheme>|light' format if only one bg style is
" needed. E.g. 'onehalfdark|dark'
let g:themes_options = ['one', 'solarized8_high|light']
if SystemDarkMode()
    colorscheme one
    set background=dark
else
    colorscheme one
    set background=light
endif

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
set foldlevel=119
set colorcolumn=120
set signcolumn=yes

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

"""""""""""""""""""""""""""""""""""""""""""""""""""
" echodoc

set cmdheight=1
set noshowmode
let g:echodoc#enable_at_startup = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""
" Hop

hi HopNextKey1 guifg=#ffb402
hi HopNextKey2 guifg=#b98302


autocmd FileType h,hpp,cpp,cxx set keywordprg=cppman

"""""""""""""""""""""""""""""""""""""""""""""""""""
" Neovide

if exists("g:neovide")
    let g:neovide_theme = 'auto'
    let g:neovide_cursor_animation_length = 0.03
    let g:neovide_input_macos_alt_is_meta = v:false
    let g:neovide_scale_factor = 1.4
    let g:neovide_scroll_animation_length = 0.1

    let g:neovide_input_use_logo=v:true
    map <D-v> "+p<CR>
    map! <D-v> <C-R>+
    tmap <D-v> <C-R>+
    vmap <D-c> "+y<CR> 
endif
