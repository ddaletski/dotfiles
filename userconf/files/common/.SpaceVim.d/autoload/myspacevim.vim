function! myspacevim#before() abort
endfunction

function! myspacevim#after() abort
    " turn hybrid line numbers off
    :set norelativenumber
    :set nornu

    " turn absolute line numbers on
    :set number
    :set nu
endfunction
