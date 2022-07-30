function! GetWordUnderCursor() 
    execute 'normal! viw9y'
    let selection = @9
    return selection
endfunction

function! GetSelectedText()
    execute '9y'
    let selection = @9
    return selection
endfunction


" =================== c++ =========================

function! ShowCppDocsCursor()
    let selection = GetWordUnderCursor()
    execute 'Cppman ' .. selection
    execute 'normal! <cr>'
endfunction

function! ShowCppDocsSelection()
    let selection = GetSelectedText()
    execute 'Cppman ' .. selection
    execute 'normal! <cr>'
endfunction

function! s:register_cpp_docs() abort
    nnoremap <silent> <buffer> <leader>lh :Cppman headers<cr>
    nnoremap <silent> <buffer> <leader>lD :call ShowCppDocsCursor()<cr>
    xnoremap <silent> <buffer> <leader>lD :call ShowCppDocsSelection()<cr>

lua << EOF
    local wk = require("which-key")

    local n_only = {
        name = "language",
        D = "show cpprefence under cursor",
        h = "open cpprefence",
    }
    local v_only = {
        name = "language",
        D = "show cpprefence for selection",
    }

    wk.register({l = n_only}, { prefix = "<leader>", mode = "n", buffer=0 })
    wk.register({l = v_only}, { prefix = "<leader>", mode = "v", buffer=0 })
EOF
endfunction
    
" register keymaps for showing cppreference
augroup cppman
  autocmd!
  au Filetype cpp call s:register_cpp_docs()
augroup END

"====================== rust ======================================

function! ShowRustDocsCursor()
    let selection = GetWordUnderCursor()
    execute 'RustDoc ' .. selection
    execute 'normal! <cr>'
endfunction

function! ShowRustDocsSelection()
    let selection = GetSelectedText()
    execute 'RustDoc ' .. selection
    execute 'normal! <cr>'
endfunction


function! s:register_rust_docs() abort
    nnoremap <silent> <buffer> <leader>lh :RustDoc std<cr>
    nnoremap <silent> <buffer> <leader>lD :call ShowRustDocsCursor()<cr>
    xnoremap <silent> <buffer> <leader>lD :call ShowRustDocsSelection()<cr>

lua << EOF
    local wk = require("which-key")

    local n_only = {
        name = "language",
        D = "show rustdoc under cursor",
        h = "open rustdoc",
    }
    local v_only = {
        name = "language",
        D = "show rustdoc for selection",
    }

    wk.register({l = n_only}, { prefix = "<leader>", mode = "n", buffer=0 })
    wk.register({l = v_only}, { prefix = "<leader>", mode = "v", buffer=0 })
EOF
endfunction
    
" register keymaps for showing rustdoc
augroup rustdoc
  autocmd!
  au Filetype rust call s:register_rust_docs()
augroup END
