" jump.vim
" Author: riko-teki
" License: MIT

if exists('loaded_jump')
  finish
endif

let g:loaded_jump = 1

command! Jump call jump#virtual_text()

nnoremap <Plug>(jump-jump) :<C-u>call jump#jump()<CR>
nmap <silent> <C-j> <Plug>(jump-jump)
