let g:mapleader = "\<Space>"
let g:maplocalleader = ','
set timeoutlen=500

" buffet
nnoremap <silent> <Tab><Tab> :BuffergatorToggle<cr>
nnoremap <silent> <Tab>n :bn<cr>
nnoremap <silent> <Tab>p :bp<cr>
nnoremap <silent> <C-t> :tabnew new-tab<cr>

" telescope
nnoremap ` :Telescope<cr>
nnoremap <C-p> :lua require'telescope.builtin'
            \.find_files(require('telescope.themes').get_dropdown({}))<cr>
nnoremap <C-f> :lua require'telescope.builtin'.live_grep{}<cr>

"================== completion ===========================
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction


"" use <Tab> to trigger completion
"inoremap <silent><expr> <Tab>
            "\ pumvisible() ? "\<Tab>" : 
            "\ <SID>check_back_space() ? "\<Tab>" : coc#refresh()

"" use <C-j> to go to the next complete item
"inoremap <silent><expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
"" <C-k> to go to the previous complete item
"imap <silent><expr> <C-k>
            "\ pumvisible() ? "\<C-p>" :
            "\ "\<C-k>"

let g:coc_snippet_next = '<Tab>'

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<cr>"

"======================== other =========================
" escape in terminal
tnoremap <Esc> <C-\><C-n>

" 'Ctrl'+'/' comments
let g:NERDToggleCheckAllLines = 1
nnoremap <silent> <C-_> :call nerdcommenter#Comment('n', 'Toggle')<cr>
xnoremap <silent> <C-_> :call nerdcommenter#Comment('n', 'Toggle')<cr>
inoremap <silent> <C-_> <C-c>:call nerdcommenter#Comment('n', 'Toggle')<cr>

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

let s:which_key_space = { 'name': 'actions' }

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
xnoremap <silent> <leader>lf  <Plug>(coc-format-selected)<cr>
nnoremap <silent> <leader>lF  :<Plug>(coc-format)<cr>

" docs
nnoremap <silent> K :call <SID>show_documentation()<cr>
nnoremap <silent> <leader>lD :call <SID>show_documentation()<cr>

function X() 
endfunction
" rename current word
nnoremap <leader>lr <Plug>(coc-rename)

let s:which_key_space.l = {
      \ 'name' : '+language',
      \ 'd' : 'diagnostics',
      \ 'e' : 'coc extensions',
      \ 'c' : 'coc commands',
      \ 'o' : 'file outline',
      \ 's' : 'symbols',
      \ 'f' : ['format selected', 'v'],
      \ 'F' : ['format buffer', 'n'],
      \ 'r' : 'rename symbol',
      \ }

      "\ 'g' : 'gen docs under cursor',
      "\ 'G' : 'gen docs for file',

"==================== errors =============================

nnoremap <silent> <leader>ek <Plug>(coc-diagnostic-prev)
nnoremap <silent> <leader>ep <Plug>(coc-diagnostic-prev)
nnoremap <silent> <leader>ej <Plug>(coc-diagnostic-next)
nnoremap <silent> <leader>en <Plug>(coc-diagnostic-next)

let s:which_key_space.e = {
            \ 'name' : '+errors',
            \ 'j' : 'next error',
            \ 'n' : 'next error',
            \ 'k' : 'prev error',
            \ 'p' : 'prev error'
            \ }

"==================== files ==============================
"
nnoremap <silent> <leader>ff :Telescope file_browser<cr>

let s:which_key_space.f = {
      \ 'name' : '+files',
      \ 'f' : 'open files browser'
      \ }

"==================== terminal ===========================
"

nnoremap <silent> <leader>t :FloatermToggle<cr>
let s:which_key_space.t = 'terminal'

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

function! OpenConfigDir() abort
    let vimrc = $MYVIMRC
    let vimDir = fnamemodify(vimrc, ':h')
    execute 'edit '.vimDir
endfunction

" reload init.vim and all autoload configs
nnoremap <silent> <Leader>vr :call ReloadAll()<cr>

"=== configs

" edit init.vim
nnoremap <silent> <Leader>vci :e $MYVIMRC<cr>
" edit keys.vim
nnoremap <silent> <Leader>vck :call OpenAutoScript('keys')<cr>
" edit plugins.vim
nnoremap <silent> <Leader>vcp :call OpenAutoScript('plugins')<cr>
" open config dir
nnoremap <silent> <Leader>vcd :call OpenConfigDir()<cr>

"=== plugins

" update plugins
function! UpdatePlugins() abort
    PlugUpdate
    CocUpdate
endfunction
nnoremap <silent> <Leader>vpu :call UpdatePlugins()<cr>

" install plugins
function! InstallPlugins() abort
    PlugInstall
    CocUpdateSync
endfunction
nnoremap <silent> <Leader>vpi :call InstallPlugins()<cr>

" clean plugins
nnoremap <silent> <Leader>vpc :PlugClean<cr>
" edit plugins.vim
nnoremap <silent> <Leader>vpe :call OpenAutoScript('plugins')<cr>

" themes selector
nnoremap <silent> <Leader>vt :call SelectTheme()<cr>

let s:which_key_space.v = {
      \ 'name' : '+vim',
      \ 'c' : {
          \ 'name': '+config',
              \ 'i' : 'edit init.vim',
              \ 'k' : 'edit keys.vim',
              \ 'p' : 'edit plugins.vim',
              \ 'd' : 'open nvim config dir'
          \ },
      \ 'p' : {
          \ 'name' : '+plugins',
          \ 'i' : 'install',
          \ 'u' : 'update',
          \ 'c' : 'clean',
          \ 'e' : 'edit plugins.vim',
          \ },
      \ 'r' : 'reload init.vim',
      \ 't' : 'select theme',
      \ }

"================== gotos ================================

nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gt <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)
nnoremap <silent> gg :1<cr>

let s:which_key_g = {
      \ 'name' : 'goto',
      \ 'd' : 'definition',
      \ 't' : 'type definition',
      \ 'i' : 'implementation',
      \ 'r' : 'references',
      \ 'g' : 'beginning of buffer'
      \ }

"====================================================

function! s:extractKeysForMode(keys_entry, mode) abort
    let entry_type = type(a:keys_entry)

    " string is passed if it's a normal mode
    if entry_type is v:t_string
        if a:mode ==? 'n'
            return a:keys_entry
        else
            return v:null
        endif

    " if keys is ['<descr.>', '<mode>'] - check if mode matches
    elseif entry_type is v:t_list
        let key_mode = a:keys_entry[1]

        if count(key_mode, a:mode) > 0
            return a:keys_entry[0]
        else
            return v:null
        endif

    " if keys is dict - call recursively for every entry
    elseif entry_type is v:t_dict

        let result = {}
        for [key, value] in items(a:keys_entry)
            if key ==? 'name'
                continue
            endif

            let parsed = s:extractKeysForMode(value, a:mode)
            if parsed isnot v:null
                let result[key] = parsed
            endif
        endfor

        " if no key is supported for a given mode - skip the whole prefix
        if empty(result) 
            return v:null
        endif

        " add prefix name
        let result['name'] = a:keys_entry['name']

        return result
    endif
endfunction

" preprocess keys descriptions to split normal and visual mode keys
function! s:registerKeysPopup(top_key, keys_dict) abort
    let keys_normal = {}
    let keys_visual = {}

    let norm = s:extractKeysForMode(a:keys_dict, 'n')
    let vis = s:extractKeysForMode(a:keys_dict, 'v')

    call which_key#register(a:top_key, norm, 'n')
    call which_key#register(a:top_key, vis, 'v')
endfunction

" register keys descriptions
nnoremap <silent> <leader> :WhichKey '<Space>'<cr>
xnoremap <silent> <leader> :WhichKeyVisual '<Space>'<cr>
call s:registerKeysPopup('<Space>', s:which_key_space)

nnoremap <silent> g :WhichKey 'g'<cr>
call s:registerKeysPopup('g', s:which_key_g)
"====================================================
