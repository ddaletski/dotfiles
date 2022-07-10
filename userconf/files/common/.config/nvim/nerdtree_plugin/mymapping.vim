function! NerdTree_out(node) abort
    let current = a:node.path
    let root = g:NERDTree.ForCurrentTab().getRoot().path
    let parent = current.getParent()
  if root.str() ==# current.str()
    silent! exe 'NERDTree' parent.str()
  elseif root.str() ==# parent.str()
    silent! exe 'NERDTree' parent.getParent().str()
  else
    call g:NERDTreeKeyMap.Invoke('p')
    call g:NERDTreeKeyMap.Invoke('o')
  endif
endfunction

function! NerdTree_in(node) abort
  let path = g:NERDTreeFileNode.GetSelected().path.str()
  if isdirectory(path)
    if matchstr(getline('.'), 'S') ==# g:NERDTreeDirArrowCollapsible
      normal! gj
    else
      call g:NERDTreeKeyMap.Invoke('o')
      normal! gj
    endif
  else
    call g:NERDTreeKeyMap.Invoke('o')
  endif
endfunction

" TODO: implement and bind to a key
"function! s:open_in_file_manager() abort
"endfunction

call NERDTreeAddKeyMap({
       \ 'key': 'l',
       \ 'callback': 'NerdTree_in',
       \ 'quickhelpText': 'open file or folder',
       \ 'scope': 'Node'
       \ })
call NERDTreeAddKeyMap({
       \ 'key': 'h',
       \ 'callback': 'NerdTree_out',
       \ 'quickhelpText': 'go one level up',
       \ 'scope': 'Node'
       \ })
