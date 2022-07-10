function! myspacevim#before() abort
    call SpaceVim#custom#SPC('nore', ['c', 'c'], 'CocList commands', 'coc commands', 1)
    call SpaceVim#custom#SPC('nore', ['c', 'o'], 'CocList outline', 'coc outline', 1)
    call SpaceVim#custom#SPC('nore', ['c', 'f'], "call CocActionAsync('formatSelected', visualmode())", 'format selected', 1)
    call SpaceVim#custom#SPC('nore', ['c', 'F'], "call CocActionAsync('format')", 'format all', 1)
endfunction

function! myspacevim#after() abort
    " coc extensions
    let g:coc_global_extensions = ['coc-highlight', 'coc-python']

    " turn hybrid line numbers off
    set norelativenumber
    set nornu

    " turn absolute line numbers on
    set number
    set nu

    " live substitution
    :set inccommand=split

    " buffet
    nnoremap <Tab> :Bufferlist<CR>

    " highlight symbol under cursor on CursorHold and show signature on CursorHoldI
    set updatetime=300
    autocmd CursorHoldI * silent call CocActionAsync('showSignatureHelp')
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " use `[g` and `]g` to navigate diagnostics
    nmap <silent> cdp <Plug>(coc-diagnostic-prev)
    nmap <silent> cdn <Plug>(coc-diagnostic-next)

    " 'Ctrl'+'/' comments
    let g:NERDToggleCheckAllLines = 1
    nnoremap <silent> <C-_> :call NERDComment('n', 'Toggle')<CR>
    xnoremap <silent> <C-_> :call NERDComment('n', 'Toggle')<CR>
    inoremap <silent> <C-_> <C-c>:call NERDComment('n', 'Toggle')<CR>

    " helpful coc lists 
    nmap <silent> <leader>co :CocList outline<cr>
    nmap <silent> <leader>cc :CocList commands<cr>

    " Remap for format selected region
    xmap <silent> <leader>cf  <Plug>(coc-format-selected)
    nmap <silent> <leader>cf  <Plug>(coc-format-selected)

endfunction
