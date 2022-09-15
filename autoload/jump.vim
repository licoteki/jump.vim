" jump.vim 
" Author: riko-teki
" License: MIT

" \zsで１文字ずつに分割
let s:fill_chars = get(s:, 'fill_chars', split('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890','\zs'))
let s:fill_chars_len = len(s:fill_chars)

let s:fill_chars_raw_address = {}
let s:fill_chars_column_address = {}


function! jump#jump() abort
  let s:start_line = line('w0')
  let s:end_line = line('w$')

  call prop_type_add('mark', {})

  let used_mark_index = s:fill_entire_window()
  redraw!

  let specified_mark = nr2char(getchar())
  
  if !has_key(s:fill_chars_raw_address, specified_mark)
    echo "Specified mark is nothing."
  else
    call popup_clear(1)
    call s:fill_line(s:fill_chars_raw_address[specified_mark])
    call cursor(s:fill_chars_raw_address[specified_mark],1)
    redraw!
    let specified_mark = nr2char(getchar())
    if !has_key(s:fill_chars_column_address, specified_mark)
      echo "Specified mark is nothing."
    else
      call cursor(0,s:fill_chars_column_address[specified_mark])
    endif
  endif

  call popup_clear(1)
  call prop_type_delete('mark', {})
  redraw!
endfunction

function! s:fill_entire_window() abort
  let mark_index = 0  
  for i in range(s:start_line, s:end_line)
    " 改行のみの行はスキップ
    if match(getline(i), '^$') !=# -1
      continue
    endif

    let fill_char = s:fill_chars[mark_index]
    call s:fill_line_same_char(i, fill_char)
    let s:fill_chars_raw_address[fill_char] = i
    let mark_index += 1
  endfor
endfunction

function! s:fill_line_same_char(line_number, fill_char) abort
  let text = substitute(getline(a:line_number),".", "x", "g")
  let text_len = strlen(text)
  " スペースとタブ以外の文字を置換 
  let replaced = substitute(text,'\S', a:fill_char,'g')
  call prop_add(line('w0'), 1, {'type': 'mark'})
  call s:popup(replaced, a:line_number) 
endfunction

function! s:fill_line(line_number) abort
  let text = getline(a:line_number)
  let text_len = strlen(getline(a:line_number))

  let mark_index = 0
  let mark = ''
  for i in range(text_len)
    if text[i] ==# ' ' || text[i] ==# "\t"
      let mark = mark.' '
      continue
    endif
    let mark = mark.s:fill_chars[mark_index] 
    let s:fill_chars_column_address[s:fill_chars[mark_index]] = i + 1
    let mark_index += 1
  endfor
  
  call prop_add(line('w0'), 1, {'type': 'mark'})
  call s:popup(mark, a:line_number) 
endfunction

function! s:popup(mark, line_number) abort
  call popup_create( a:mark, {
    \ 'textprop': 'mark',
    \ 'highlight': 'ErrorMsg',
    \ 'line': a:line_number - line('w0') - 1,
    \ 'col': 0,
    \ 'zindex': 49,
    \})
endfunction
