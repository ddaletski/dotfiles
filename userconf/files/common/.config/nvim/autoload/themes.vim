" TODO: theme caching for user

function! SelectThemeByIndex(theme_idx) abort
    if a:theme_idx < 0 || a:theme_idx >= len(g:themes_options)
        echom "can't select the colorscheme #" . a:theme_idx 
                    \ . ". Index is out of range [0, " . len(g:themes_options) . ")"
        return
    endif
    exec 'colorscheme ' . g:themes_options[a:theme_idx]
endfunction

function! SelectTheme() abort
    let last_scheme = s:catchExOutput('colorscheme')

    let prompt = 'colorscheme'
    let width = s:winWidth(g:themes_options + [prompt])
    let s:height = 4 + len(g:themes_options)

    " create or get a buffer
    if !bufexists(s:bufname)
        let buf = nvim_create_buf(v:false, v:true)
        call nvim_buf_set_name(buf, s:bufname)
        call nvim_buf_set_option(buf, 'buftype', 'nofile')
    else
        let buf = bufnr(s:bufname)
    endif
    call nvim_buf_set_option(buf, 'modifiable', v:true)

    let horizontal_border = '+' . repeat('-', width - 2) . '+'
    let empty_line = '|' . repeat(' ', width - 2) . '|'

    " border - header - border - ...themes - border
    let lines = flatten([
                \ horizontal_border, 
                \ empty_line,
                \ horizontal_border, 
                \ repeat([empty_line], len(g:themes_options)), 
                \ horizontal_border
                \ ])
    " set the box in the buffer
    call nvim_buf_set_lines(buf, 0, -1, v:false, lines)

    " print header
    call s:addCenteredText(buf, width, 1, prompt)

    " print all themes
    let offset = 0
    for theme in g:themes_options
        call s:addCenteredText(buf, width, 3 + offset, theme)
        let offset += 1
    endfor

    " Set mappings in the buffer to close the window easily 
    " and return the previous scheme
    let closingKeys = ['<Esc>', 'q', '<Leader>', '<C-w>', '<Tab>']
    for closingKey in closingKeys
        call nvim_buf_set_keymap(buf, 'n', closingKey, ':colorscheme ' . last_scheme . ' | q<cr>',
                    \ {'silent': v:true, 'nowait': v:true, 'noremap': v:true})
    endfor

    call nvim_buf_set_keymap(buf, 'n', '<cr>', ':call SelectThemeByIndex(line(".")-4) | :q<cr>',
                \ {'silent': v:true, 'nowait': v:true, 'noremap': v:true})

    " autocommand for changed line number (theme)
    function s:onLineIndexChanged(line_idx) abort
        let line_num = a:line_idx
        " force cursor in themes list
        if line_num < 3
            4
            let line_num = 3
        elseif line_num >= s:height - 1
            exec(s:height - 1)
            let line_num = s:height - 2
        endif

        let theme_idx = line_num - 3

        let buf = bufnr(s:bufname)
        call nvim_buf_clear_namespace(buf, -1, 0, -1)
        call nvim_buf_add_highlight(buf, -1, 'PmenuSel', line_num, 0, -1)

        call SelectThemeByIndex(theme_idx)
    endfunction

	augroup __group__theme_select__
	  autocmd!
      autocmd CursorMoved __theme_select__ call s:onLineIndexChanged(line('.')-1)
	augroup END

    " Create the floating window
    let ui = nvim_list_uis()[0]
    let opts = {'relative': 'editor',
                \ 'width': width,
                \ 'height': s:height,
                \ 'col': (ui.width/2) - (width/2),
                \ 'row': (ui.height/2) - (s:height/2),
                \ 'anchor': 'NW',
                \ 'style': 'minimal',
                \ 'border': '',
                \ }
    let win = nvim_open_win(buf, 1, opts)

    " Change highlighting
    call nvim_win_set_option(win, 'winhl', 'Normal:Pmenu')

    call nvim_buf_set_option(buf, 'modifiable', v:false)

    let curr_idx = s:currentColorschemeIdx()
    exec (curr_idx + 4)
endfunction

" =============== private ==================
function! s:winWidth(lines) abort
    return 2 + max(map(a:lines, {idx, line -> len(line)}))
endfunction

function! s:addCenteredText(buf, width, row, text) abort
    let start_col = (a:width - len(a:text))/2
    let end_col = start_col + len(a:text)
    call nvim_buf_set_text(a:buf, a:row, start_col, a:row, end_col, [a:text])
endfunction

function! s:catchExOutput(cmd) abort
    let result = ''
    redir => result | exec('silent ' . a:cmd) | redir END
    return trim(result)
endfunction

function! s:currentColorschemeIdx() abort
    let current = s:catchExOutput('colorscheme')
    return index(g:themes_options, current)
endfunction

let s:bufname = '__theme_select__'

