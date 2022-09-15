" jump.vim
" Author: riko-teki
" License: MIT

" \zsデリミタで文字列を個々の文字列に分割できる
let g:fill_chars = get(g:, 'fill_chars', split('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890','\zs'))
let g:fill_chars_len = len(g:fill_chars)

function! jump#jump() abort
  let s:start_line = line('w0')
  let s:end_line = line('w$') 
  call s:fill_entire_window()
  redraw!

  let specified_mark = nr2char(getchar())
  echo specified_mark
  
  call popup_clear(1)
  redraw!

"  call s:fill_line()
endfunction

function! s:calculate_raw_address(start_line,end_line,specified_mark) abort
   
endfunction

function! s:fill_entire_window() abort
  call prop_type_add('mark', {})
  let buf_number = bufnr()
 
  let l:current_line = s:start_line 
  
  while current_line <= s:end_line
    let fill_char = g:fill_chars[current_line - s:start_line]
    "call jump#fill_line_same_char(current_line, fill_char)
    call s:fill_line(current_line)
    let current_line += 1
  endwhile
endfunction

function! s:fill_line_same_char(line_number, fill_char) abort
  call prop_add(a:line_number,1, { 'type': 'mark' })
  let text = getline(a:line_number)
  let text_len = strlen(getline(a:line_number))
  " スペースとタブ以外の文字を置換 
  let replaced = substitute(text,'\S', a:fill_char,'g')
  call popup_create( replaced, {
    \ 'textprop': 'mark',
    \ 'highlight': 'ErrorMsg',
    \ 'line': -2 + a:line_number,
    \ 'col': 0,
    \ 'zindex': 49,
    \})
endfunction

function! s:fill_line(line_number) abort
  call prop_add(a:line_number,1, { 'type': 'mark' })
  let text = getline(a:line_number)
  let text_len = strlen(getline(a:line_number))

  let mark_index = 0
  let mark = ''
  for i in range(text_len)
    if text[i] ==# ' ' || text[i] ==# "\t"
      let mark = mark.' '
      continue
    endif
    let mark = mark.g:fill_chars[mark_index] 
    let mark_index += 1
  endfor
  
  call popup_create( mark, {
    \ 'textprop': 'mark',
    \ 'highlight': 'ErrorMsg',
    \ 'line': -2 + a:line_number,
    \ 'col': 0,
    \ 'zindex': 49,
    \})
endfunction
