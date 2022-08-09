" TODO: theme caching for user

function! AvailableThemes() abort
    let themes = []

    for theme in g:themes_options
        if count(theme, '|') > 0 " bg is specified
            let [name, bg_tone] = split(theme, '|')

            if bg_tone !=# 'light' && bg_tone !=# 'dark'
                echoerr "unsupported bg tone " . bg_tone . " in color theme " . theme
            endif

            call add(themes, [name, bg_tone])
        else " bg is not specified - add both
            let name = theme

            call add(themes, [name, 'light'])
            call add(themes, [name, 'dark'])
        endif
    endfor

    return themes
endfunction

function! SelectThemeByIndex(theme_idx) abort
    let available_themes = AvailableThemes()

    if a:theme_idx < 0 || a:theme_idx >= len(available_themes)
        echoerr "can't select the colorscheme #" . a:theme_idx 
                    \ . ". Index is out of range [0, " . len(available_themes) . ")"
        return
    endif

    let [scheme, bg_tone] = available_themes[a:theme_idx]
    let &bg=bg_tone
    exec 'colorscheme ' . scheme
endfunction

function! SelectTheme() abort
    let available_themes = AvailableThemes()

    function! s:format_item(theme_item) 
        let [name, bg_tone] = a:theme_item
        return name . ' ' . bg_tone
    endfunction
    let themes_labels = map(available_themes, {idx, item -> s:format_item(item)})

    let last_scheme = s:catchExOutput('colorscheme')
    let last_bg = &background

    let prompt = 'colorscheme'
    let width = s:winWidth(themes_labels + [prompt])
    let s:height = 4 + len(available_themes)

    " create or get a buffer
    if !bufexists(s:bufname)
        let buf = nvim_create_buf(v:false, v:true)
        call nvim_buf_set_name(buf, s:bufname)
        call nvim_buf_set_option(buf, 'buftype', 'nofile')
    else
        let buf = bufnr(s:bufname)
    endif
    call nvim_buf_set_option(buf, 'modifiable', v:true)

    let top_border = "╔" . repeat("═", width - 2) . "╗"
    let mid_border = "╟" . repeat("┄", width - 2) . "╢"
    let empty_line = "║" . repeat(" ", width - 2) . "║"
    let bot_border = "╚" . repeat("═", width - 2) . "╝"

    let lines = flatten([
                \ top_border, 
                \ empty_line,
                \ mid_border, 
                \ repeat([empty_line], len(available_themes)), 
                \ bot_border
                \ ])
    " set the box in the buffer
    call nvim_buf_set_lines(buf, 0, -1, v:false, lines)

    " print header
    call s:addCenteredText(buf, width, 1, prompt)

    " print all themes
    let offset = 0
    for theme in themes_labels
        call s:addLeftAlignedText(buf, width, 3 + offset, theme)
        let offset += 1
    endfor

    " Set mappings in the buffer to close the window easily 
    " and return the previous scheme
    let closingKeys = ['<Esc>', 'q', '<Leader>', '<C-w>', '<Tab>']

    let close_cmd = ':colorscheme '..last_scheme..' | set background='..last_bg..' | :q<cr>'
    echom close_cmd
    for closingKey in closingKeys
        call nvim_buf_set_keymap(buf, 'n', closingKey, close_cmd,
                    \ {'silent': v:true, 'nowait': v:true, 'noremap': v:true})
    endfor

    call nvim_buf_set_keymap(buf, 'n', '<cr>', ':call SelectThemeByIndex(line(".")-4) | :q<cr>',
                \ {'silent': v:true, 'nowait': v:true, 'noremap': v:true})

    " autocommand for changed line number (theme)
    function! s:onLineIndexChanged(line_idx) abort
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
    return 4 + max(map(a:lines, {idx, line -> len(line)}))
endfunction

function! s:addLeftAlignedText(buf, width, row, text) abort
    let start_col = 4
    let end_col = start_col + len(a:text)
    call nvim_buf_set_text(a:buf, a:row, start_col, a:row, end_col, [a:text])
endfunction

function! s:addCenteredText(buf, width, row, text) abort
    let start_col = 2 + (a:width - len(a:text))/2
    let end_col = start_col + len(a:text)
    call nvim_buf_set_text(a:buf, a:row, start_col, a:row, end_col, [a:text])
endfunction

function! s:catchExOutput(cmd) abort
    let result = ''
    redir => result | exec('silent ' . a:cmd) | redir END
    return trim(result)
endfunction

function! s:currentColorschemeIdx() abort
    let available_themes = AvailableThemes()

    let scheme = s:catchExOutput('colorscheme')
    let bg_tone = &background

    let current = [scheme, bg_tone]
    return index(available_themes, current)
endfunction

let s:bufname = '__theme_select__'

