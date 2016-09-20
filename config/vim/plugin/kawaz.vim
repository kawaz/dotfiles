" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" plugin にあるものは vim 起動時に読み込まれる

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
