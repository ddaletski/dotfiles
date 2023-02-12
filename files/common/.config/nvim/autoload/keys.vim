let g:mapleader = "\<Space>"
let g:maplocalleader = ','
set timeoutlen=500

" buffers
nnoremap <silent> <Tab>l :Telescope buffers<cr>
nnoremap <silent> <Tab>n :bn<cr>
nnoremap <silent> <Tab>p :bp<cr>

" telescope
nnoremap ` :Telescope<cr>
nnoremap <silent> <C-p> :Telescope find_files<cr>
nnoremap <silent> <C-f> :Telescope current_buffer_fuzzy_find<cr>
"================== completion ===========================
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

""" use <C-j> to go to the next complete item
inoremap <silent><expr> <C-j> coc#pum#visible() ? coc#pum#next(1) : "\<C-j>"
""" <C-k> to go to the previous complete item
imap <silent><expr> <C-k>
            \ coc#pum#visible() ? coc#pum#prev(1) :
            \ "\<C-k>"

let g:coc_snippet_next = '<Tab>'

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

"======================== other =========================
" escape in terminal
tnoremap <Esc> <C-\><C-n>

" clean selection by <cr>
nnoremap <silent> <cr> :noh<cr><cr>

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

" rename current word
nnoremap <leader>lr <Plug>(coc-rename)

" quickfix
xnoremap <silent> <leader>lq <Plug>(coc-codeaction-selected)<cr>
nnoremap <silent> <leader>lq <Plug>(coc-codeaction-selected)<cr>

lua << EOF
local wk = require("which-key")

local base = {
    name = "language",
    d = "diagnostics",
    o = "file outline",
    s = "symbols",
    r = "rename symbol",
    q = "quickfix"
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

let docs_config_path = $HOME . '/.config/nvim/autoload/keys_docs.vim'
exe 'source' docs_config_path

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
nnoremap <silent> <leader>f<Tab> :Telescope file_browser<cr>
nnoremap <silent> <leader>ff :Telescope current_buffer_fuzzy_find<cr>
nnoremap <silent> <leader>fF :Telescope live_grep<cr>
nnoremap <silent> <leader>fr :CocCommand workspace.renameCurrentFile<cr>

lua << EOF
local wk = require("which-key")

local n_only = {
    name = "files",
    ["<Tab>"] = "open files browser",
    f = "find in file",
    F = "find in cwd",
    r = "rename current file",
}

wk.register({f = n_only}, { prefix = "<leader>", mode = "n" })
EOF

"==================== terminal ===========================

nnoremap <silent> <leader>t :FloatermToggle<cr>

lua << EOF
local wk = require("which-key")
wk.register({t = "terminal"}, { prefix = "<leader>", mode = "n" })
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

"=== show startup screen
nnoremap <silent> <Leader>vs :Alpha<cr>

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
    s = "startup screen",
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

"=================== hop ================================

nnoremap <silent> fw :HopWord<cr>
nnoremap <silent> ff :HopChar1<cr>
nnoremap <silent> fb :HopChar2<cr>
nnoremap <silent> fl :HopLineStart<cr>
nnoremap <silent> fp :HopPattern<cr>

lua << EOF
local wk = require("which-key")

local n_only = {
      name = "find",
      w = "word",
      f = "character",
      b = "bi-character",
      l = "line",
      p = "pattern",
}
wk.register({f = n_only}, { mode = "n" })
EOF

"==================== vimspector =============================

nmap <Leader>da :echo vimspector#GetConfigurations()<cr>
nmap <Leader>dl :call vimspector#Launch()<cr>
nmap <Leader>dq :call vimspector#Reset()<cr>

" for normal mode - the word under the cursor
nmap <Leader>de <Plug>VimspectorBalloonEval<cr>
" for visual mode, the visually selected text
xmap <Leader>de <Plug>VimspectorBalloonEval<cr>


"<Plug>VimspectorGoToCurrentLine
nmap <silent> <Leader>dr <Plug>VimspectorRunToCursor<cr>
nmap <silent> <Leader>dc <Plug>VimspectorContinue<cr>
nmap <silent> <Leader>dS <Plug>VimspectorStop<cr>
nmap <silent> <Leader>dR <Plug>VimpectorRestart<cr>
nmap <silent> <Leader>dp <Plug>VimspectorPause<cr>

nmap <silent> <C-j> <Plug>VimspectorStepOver<cr>
nmap <silent> <C-i> <Plug>VimspectorStepInto<cr>
nmap <silent> <C-q> <Plug>VimspectorStepOut<cr>

nmap <silent> <Leader>dj <Plug>VimspectorStepOver<cr>
nmap <silent> <Leader>dn <Plug>VimspectorStepOver<cr>
nmap <silent> <Leader>di <Plug>VimspectorStepInto<cr>
nmap <silent> <Leader>do <Plug>VimspectorStepOut<cr>

nmap <silent> <Leader>dfk <Plug>VimspectorDownFrame<cr>
nmap <silent> <Leader>dfu <Plug>VimspectorDownFrame<cr>
nmap <silent> <Leader>dfp <Plug>VimspectorDownFrame<cr>

nmap <silent> <Leader>dfj <Plug>VimspectorUpFrame<cr>
nmap <silent> <Leader>dfd <Plug>VimspectorUpFrame<cr>
nmap <silent> <Leader>dfn <Plug>VimspectorUpFrame<cr>

nmap <silent> <Leader>db<Tab> <Plug>VimspectorBreakpoints<cr>
nmap <silent> <Leader>dbb <Plug>VimspectorToggleBreakpoint<cr>
nmap <silent> <Leader>dbc <Plug>VimspectorToggleConditionalBreakpoint<cr>
nmap <silent> <Leader>dbf <Plug>VimspectorAddFunctionBreakpoint<cr>
nmap <silent> <Leader>dbD :call vimspector#ClearBreakpoints()<cr>

" TODO: add watch maps
"vimspector#AddWatch(
"vimspector#AddWatchPrompt(
"vimspector#DeleteWatch()
"vimspector#OmniFuncWatch(

"vimspector#ExpandVariable()
"vimspector#OmniFuncConsole(

lua << EOF
local wk = require("which-key")

local n_only = {
    name = "debug",
    a = "show all configurations",
    l = "launch",
    q = "quit",
    e = "evaluate expr under cursor",
    r = "run to cursor",
    c = "continue",
    S = "stop",
    R = "restart",
    p = "pause",

    j = "step over",
    n = "step over",
    i = "step into",
    o = "step out",

    f = {
        name = "frame",
        k = "go up one frame",
        u = "go up one frame",
        p = "go up one frame",
        j = "go down one frame",
        d = "go down one frame",
        n = "go down one frame",
    },
    b = {
        name = "breakpoints",
        ["<Tab>"] = "show/hide breakpoints window",
        b = "toggle breakpoint",
        c = "toggle conditional breakpoint",
        f = "add function breakpoint",
        D = "clear all breakpoints",
    },
    w = {
        name = "watch"
    }
}

local v_only = {
    name = "debug",
    e = "evaluate selected expression",
}

wk.register({d = n_only}, { prefix = "<leader>", mode = "n" })
wk.register({v = v_only}, { prefix = "<leader>", mode = "v" })
EOF

"================ help ====================================

nnoremap <silent> <leader>hk :WhichKey<cr>
nnoremap <silent> <leader>hh :Telescope help_tags<cr>
nnoremap <silent> <leader>hm :Telescope man_pages<cr>

lua << EOF
local wk = require("which-key")

local n_only = {
    name = "help",
    k = "show all keymaps",
    h = "list of help tags",
    m = "list man pages",
}


wk.register({h = n_only}, { prefix = "<leader>", mode = "n" })
EOF

"============== git =======================================

nnoremap <silent> <leader>gs :Telescope git_status<cr>
nnoremap <silent> <leader>gl :Telescope git_commits<cr>
nnoremap <silent> <leader>gb :Telescope git_branches<cr>

lua << EOF
local wk = require("which-key")

local n_only = {
    name = "git",
    l = "log",
    s = "status",
    b = "branches",
}


wk.register({g = n_only}, { prefix = "<leader>", mode = "n" })
EOF
