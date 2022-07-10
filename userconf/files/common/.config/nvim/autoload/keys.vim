let g:mapleader = "\<Space>"
let g:maplocalleader = ','
set timeoutlen=500

" buffet
nnoremap <silent> <Leader><Tab> :BuffergatorToggle<CR>
noremap <silent> <Tab> :bn<CR>
noremap <silent> <S-Tab> :bp<CR>
noremap <silent> <C-t> :tabnew new-tab<CR>

" telescope
nnoremap ` :Telescope<CR>

"================== completion ===========================
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" use <tab> for trigger completion and navigate to the next complete item
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" shift + <tab> to navigate to the previous complete item
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

"======================== other =========================
" escape in terminal
tnoremap <Esc> <C-\><C-n>

" 'Ctrl'+'/' comments
let g:NERDToggleCheckAllLines = 1
nnoremap <silent> <C-_> :call nerdcommenter#Comment('n', 'Toggle')<CR>
xnoremap <silent> <C-_> :call nerdcommenter#Comment('n', 'Toggle')<CR>
inoremap <silent> <C-_> <C-c>:call nerdcommenter#Comment('n', 'Toggle')<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

"========================================================
"================== keys helper =========================
"========================================================
"
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
let g:which_key_space = { 'name': 'actions' }

"================== language specific ====================
" Show all diagnostics
nnoremap <silent> <leader>ld  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <leader>le  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <leader>lc  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <leader>lo  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <leader>ls  :<C-u>CocList -I symbols<cr>

" format
xnoremap <silent> <leader>lf  <Plug>(coc-format-selected)
nnoremap <silent> <leader>lf  <Plug>(coc-format-selected)
nnoremap <silent> <leader>lF  :call CocAction('format')<cr>


" docs
nnoremap <silent> K :call <SID>show_documentation()<CR>
nnoremap <silent> <leader>lD :call <SID>show_documentation()<CR>

" rename current word
nnoremap <leader>lr <Plug>(coc-rename)

nmap <silent> <leader>lg <Plug>(coc-codeaction-line)
xmap <silent> <leader>lg <Plug>(coc-codeaction-selected)
nmap <silent> <leader>lG <Plug>(coc-codeaction)

let g:which_key_space.l = {
      \ 'name' : '+language',
      \ 'd' : 'diagnostics',
      \ 'e' : 'coc extensions',
      \ 'c' : 'coc commands',
      \ 'o' : 'file outline',
      \ 's' : 'symbols',
      \ 'f' : 'format selected',
      \ 'F' : 'format buffer',
      \ 'r' : 'rename symbol',
      \ 'g' : 'gen docs under cursor',
      \ 'G' : 'gen docs for file',
      \ }

"==================== errors =============================

nnoremap <silent> <leader>ek <Plug>(coc-diagnostic-prev)
nnoremap <silent> <leader>ep <Plug>(coc-diagnostic-prev)
nnoremap <silent> <leader>ej <Plug>(coc-diagnostic-next)
nnoremap <silent> <leader>en <Plug>(coc-diagnostic-next)

let g:which_key_space.e = {
            \ 'name' : '+errors',
            \ 'j' : 'next error',
            \ 'n' : 'next error',
            \ 'k' : 'prev error',
            \ 'p' : 'prev error'
            \ }

"==================== files ==============================
"
" toggle NERDTree
nnoremap <silent> <Leader>ff :NERDTreeToggle<cr>

let g:which_key_space.f = {
      \ 'name' : '+files',
      \ 'f' : 'toggle files tree'
      \ }

"===================== vim ===============================

if (!exists('*ReloadAll'))
    function! ReloadAll() abort
        source $MYVIMRC
        " TODO: reload current buffer to redraw reloaded powerline
    endfunction
endif

function! AutoloadDir() abort
    let vimrc = $MYVIMRC
    let vimDir = fnamemodify(vimrc, ':h')
    return vimDir . '/autoload'
endfunction

function! OpenAutoScript(name) abort
    let autoloadDir = AutoloadDir()
    let scriptPath = autoloadDir . '/' . a:name . '.vim'

    execute 'edit ' . scriptPath
endfunction


" reload init.vim and all autoload configs
nnoremap <silent> <Leader>vr :call ReloadAll()<cr>
" edit init.vim
nnoremap <silent> <Leader>vi :e $MYVIMRC<cr>
" edit keys.vim
nnoremap <silent> <Leader>vk :call OpenAutoScript('keys')<cr>
" edit plugins.vim
nnoremap <silent> <Leader>vp :call OpenAutoScript('plugins')<cr>

let g:which_key_space.v = {
      \ 'name' : '+vim',
      \ 'i' : 'edit init.vim',
      \ 'r' : 'reload init.vim',
      \ 'k' : 'edit keys.vim',
      \ 'p' : 'edit plugins.vim',
      \ }

"================== gotos ================================

nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gt <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)

" TODO: register 'g' in helper w/o resetting 'gg' and other default bindings
"nnoremap <silent> g :WhichKey 'g'<CR>
"let g:which_key_g = {
      "\ 'name' : 'goto',
      "\ 'd' : 'definition',
      "\ 't' : 'type definition',
      "\ 'i' : 'implementation',
      "\ 'r' : 'references',
      "\ 'g' : 'beginning of buffer',
      "\ 'G' : 'end of buffer',
      "\ }

"====================================================
" register keys descriptions
call which_key#register('<Space>', "g:which_key_space")
"call which_key#register('g', "g:which_key_g")
"====================================================
