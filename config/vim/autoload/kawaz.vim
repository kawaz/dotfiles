" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" autoload にあるものは必要になった時に読み込まれる

function! kawaz#foo()
  echo "foo"
endfunction

function! kawaz#bar()
  echo "bar"
endfunction


" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
