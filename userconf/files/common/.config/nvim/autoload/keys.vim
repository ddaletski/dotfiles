let g:mapleader = "\<Space>"
let g:maplocalleader = ','
set timeoutlen=500

" buffergator
nnoremap <silent> <Tab><Tab> :BuffergatorToggle<cr>
nnoremap <silent> <Tab>n :bn<cr>
nnoremap <silent> <Tab>p :bp<cr>
nnoremap <silent> <C-t> :tabnew new-tab<cr>
augroup buffergator
    autocmd!
    "autocmd BufEnter \[\[buffergator-buffers\]\] echom 'entered buffer ' . bufname(bufnr())
    "autocmd BufEnter [buffergator-buffers] nnoremap <Esc> <buffer> :BuffergatorToggle<cr>
augroup END

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
" Show symbols of current document
nnoremap <silent> <leader>lo  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <leader>ls  :<C-u>CocList -I symbols<cr>

" format
xnoremap <silent> <leader>lf  <Plug>(coc-format-selected)<cr>
nnoremap <silent> <leader>lF  <Plug>(coc-format)<cr>

" docs
nnoremap <silent> K :call <SID>show_documentation()<cr>
nnoremap <silent> <leader>lD :call <SID>show_documentation()<cr>

" rename current word
nnoremap <leader>lr <Plug>(coc-rename)

lua << EOF
local wk = require("which-key")

local base = {
    name = "language",
    d = "diagnostics",
    D = "show docs",
    o = "file outline",
    s = "symbols",
    r = "rename symbol",
}

local n_only = {
    name = "language",
    F = "format buffer"
}

local v_only = {
    name = "language",
    f = "format selection"
}

wk.register({l = base}, { prefix = "<leader>", mode = "n" })
wk.register({l = n_only}, { prefix = "<leader>", mode = "n" })

wk.register({l = base}, { prefix = "<leader>", mode = "v" })
wk.register({l = v_only}, { prefix = "<leader>", mode = "v" })
EOF

"==================== errors =============================

nnoremap <silent> <leader>ek <Plug>(coc-diagnostic-prev)
nnoremap <silent> <leader>ep <Plug>(coc-diagnostic-prev)
nnoremap <silent> <leader>ej <Plug>(coc-diagnostic-next)
nnoremap <silent> <leader>en <Plug>(coc-diagnostic-next)

lua << EOF
local wk = require("which-key")

local n_only = {
    name = "errors",
    j = "next error",
    n = "next error",
    k = "prev error",
    p = "prev error"
}
wk.register({e = n_only}, { prefix = "<leader>", mode = "n" })
EOF


"==================== files ==============================
"
nnoremap <silent> <leader>ff :Telescope file_browser<cr>

lua << EOF
local wk = require("which-key")

local n_only = {
    name = "files",
    f = "open files browser"
}

wk.register({f = n_only}, { prefix = "<leader>", mode = "n" })
EOF

"==================== terminal ===========================

nnoremap <silent> <leader>t :FloatermToggle<cr>

lua << EOF
local wk = require("which-key")
wk.register({t = 'terminal'})
EOF

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

nnoremap <silent> <Leader>vpi :PlugInstall<cr>
nnoremap <silent> <Leader>vpu :PlugUpdate<cr>
nnoremap <silent> <Leader>vpc :PlugClean<cr>
" edit plugins.vim
nnoremap <silent> <Leader>vpe :call OpenAutoScript('plugins')<cr>

"=== themes selector
nnoremap <silent> <Leader>vt :call SelectTheme()<cr>

lua << EOF
local wk = require("which-key")

local n_only = {
    name = "vim",
    c = {
        name = "configs",
        i = "edit init.vim",
        k = "edit keys.vim",
        p = "edit plugins.vim",
        d = "open nvim config dir",
    },
    p = {
        name = "plugins",
        i = "install",
        u = "update",
        c = "clean",
        e = "edit plugins.vim",
    },
    r = "reload init.vim",
    t = "select theme",
}
wk.register({v = n_only}, { prefix = "<leader>", mode = "n" })
EOF

"==================== coc ==================================

nnoremap <silent> <leader>ce :CocList extensions<cr>
nnoremap <silent> <leader>cc :CocList commands<cr>
nnoremap <silent> <leader>ci :CocInstall<cr>
nnoremap <silent> <leader>cu :CocUpdateSync<cr>

lua << EOF
local wk = require("which-key")

local n_only = {
      name = "coc",
      e = "coc extensions",
      c = "coc commands",
      i = "install coc plugins",
      u = "update coc plugins",
}
wk.register({c = n_only}, { prefix = "<leader>", mode = "n" })
EOF

"================== gotos ================================

nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gt <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)

lua << EOF
local wk = require("which-key")

local n_only = {
      name = "goto",
      d = "definition",
      t = "type definition",
      i = "implementation",
      r = "references",
      g = "beginning of buffer"
}
wk.register({g = n_only}, { mode = "n" })
EOF

