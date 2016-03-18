if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

" dein settings {{{
if !&compatible
  set nocompatible
endif
let s:cache_home = $XDG_CACHE_HOME == '' ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif
let &runtimepath = s:dein_repo_dir .",". &runtimepath
call dein#begin(s:dein_dir)
if dein#load_cache()
  call dein#add('Shougo/dein.vim') " プラグイン管理
  call dein#add('Shougo/deoplete.nvim', {'on_i': 1}) " コード補完
  call dein#add('othree/eregex.vim') " %S/// でpreg正規表現を使えるように
  call dein#add('w0ng/vim-hybrid') " colorscheme
  call dein#add('thinca/vim-quickrun') " \r で即時実行
  call dein#add('bronson/vim-trailing-whitespace') " 行末の空白の可視化＆ :FixWhitespace で削除
  call dein#add('kien/ctrlp.vim') " C-pでファイル選択が捗る http://bit.ly/NuXA5u
  call dein#add('airblade/vim-gitgutter') " 行番号の左側にdiffの+-とかが表示されるようにする、[c と ]c で前後のHunkに移動できる。
  call dein#add('tyru/caw.vim') " 簡単コメント、Ctr+/ でカーソル行or選択範囲をコメントトグル
  call dein#add('tyru/open-browser.vim') " gx でカーソル位置のURLや単語をブラウザで開くorググる
  call dein#add('godlygeek/tabular') " :Tabularize /, とかでアライン整形（使い方メモ http://teotr.github.io/blog/2011/04/15/tabular/
  " languages
  "" rust
  call dein#add('racer-rust/vim-racer', {'on_ft': ['rust']}) " completion (C-x C-o) and navigation (:gd goto definition)
  call dein#add('rust-lang/rust.vim', {'on_ft': ['rust']})
  call dein#add('rhysd/rust-doc.vim', {'on_ft': ['rust']})
  call dein#add('kawaz/rustsrcpath.vim', {'on_ft': ['rust'], 'depends': ['vim-racer']})
  "" markdown
  call dein#add('joker1007/vim-markdown-quote-syntax', {'on_ft': ['markdown']})
  call dein#add('rcmdnk/vim-markdown', {'on_ft': ['markdown'], 'depends':['tabular', 'vim-markdown-quote-syntax']})
  call dein#add('kannokanno/previm') " 外部コマンドに依存しないMarkdownプレビュー、open-browser.vimとリアルタイムプレビューできて素敵
  "" bash
  call dein#add('vim-scripts/bats.vim', {'on_ft': ['sh']})
  "" go
  call dein#add('zchee/deoplete-go', {'on_ft': ['go'], 'build': {'unix': 'make'}}) " golang completion
  call dein#add('fatih/vim-go', {'on_ft': ['go']}) "
  "" test
  call dein#add('janko-m/vim-test') " テストコードへジャンプ
  "" 装飾
  " airline
  call dein#add('vim-airline/vim-airline-themes')
  call dein#add('vim-airline/vim-airline', {'depends': ['vim-airline-themes']})
  " tags
  call dein#add('majutsushi/tagbar') " tagsの凄い奴
  call dein#add('soramugi/auto-ctags.vim') " 自動でctagsを実行する
  " syntastic vs neomake
  call dein#add('kawaz/batscheck.vim', {'on_ft': ['sh']})
  call dein#add('kawaz/shellcheck.vim', {'on_ft': ['sh']})
  call dein#add('scrooloose/syntastic') " ファイル保存時にエラー行があればハイライトする
  call dein#add('benekastah/neomake') " asynchronous linter, instead of 'scrooloose/syntastic'
  call dein#save_cache()
endif
call dein#end()
if dein#check_install()
  call dein#install()
endif
" }}}

" OS判定
let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_mac = !s:is_windows && !s:is_cygwin && (has('mac') || has('macunix') || has('gui_macvim') || system('uname') =~? '^darwin')
" どこか最初に書いておく
augroup MyAutoCmd
  autocmd!
augroup END
" dein#tap()の代わりに使うとブロック内で s:{s:on_source}() という関数定義をするだけでフックが登録出来るようになる
function! s:dein_tap(name) abort
  if dein#tap(a:name)
    let s:on_source = substitute(a:name, '\W', '_', 'g') . '_on_source'
    execute 'autocmd MyAutoCmd User dein#source#' . a:name . ' if exists("*s:' . s:on_source . '") | call s:' . s:on_source . '() | endif'
    return 1
  endif
  return 0
endfunction

if dein#tap('deoplete.nvim')
  let g:deoplete#enable_at_startup = 1
  let g:deoplete#enable_smart_case = 1
  let g:deoplete#sources#go#package_dot = 1
  set completeopt+=noinsert " 最初の候補がデフォで選択されるようにする
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
  if has('nvim') && !has('python3')
    echo "require python3 https://gist.github.com/kawaz/393c7f62fe6e857cc3d9"
  endif
endif

if s:dein_tap('deoplete-go')
  let g:deoplete#sources#go#align_class = 1
  let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
  " MEMO: gocode set autobuild してfalseだったら
  " gocode set autobuild true するとvendorディレクトリ内も保管できるようになる
  " またはgo buildしてあるパッケージは補完出来るのでそれがよければautobuildは不用
endif

if s:dein_tap('vim-go')
  " MEMO: gocode set autobuild true を実行しておくとvendor内のライブラリ補完もできるようになる
  let g:go_fmt_command = "goimports"
  let g:go_highlight_functions = 1
  let g:go_highlight_methods = 1
  let g:go_highlight_structs = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_build_constraints = 1
  let g:go_term_enabled = 1
  if dein#tap('syntastic')
    let g:syntastic_go_checkers = ['golint', 'gotype', 'govet', 'go']
  endif
  " TODO: キーマップはまだ確認してないので後でやる
  " 関連ツールのチェック
  function! s:{s:on_source}() abort
    if executable('go')
      for s:command in ['goimports', 'godef', 'golint', 'gocode', 'gotags', 'gorename']
        if !executable(s:command)
          echo s:command . " is not found. Please run :GoInstallBinaries or :GoUpdateBinaries"
          break
        endif
      endfor
    endif
  endfunction
endif

if dein#tap('janko-m/vim-test')
  let g:test#strategy = 'neovim' " neovim最適化?
  " mappings
  nmap <silent> <leader>f :TestNearest<CR>
  nmap <silent> <leader>i :TestFile<CR>
  nmap <silent> <leader>a :TestSuite<CR>
  nmap <silent> <leader>l :TestLast<CR>
  nmap <silent> <leader>g :TestVisit<CR>
  " 言語ごとのオプション
  let test#python#pytest#options = {'nearest': '-v', 'file': '-v', 'suite': '-v'}
  let test#go#gotest#options     = {'nearest': '-v', 'file': '-v', 'suite': '-v'}
endif

if dein#tap('vim-hybrid')
  let g:hybrid_custom_term_colors = 1
  let g:hybrid_reduced_contrast = 1 " Remove this line if using the default palette.
  colorscheme hybrid
  set background=dark
endif

if dein#tap('ctrlp.vim')
  let g:ctrlp_use_migemo = 1
endif

if dein#tap('vim-gitgutter')
  let g:gitgutter_sign_modified = 'M'
endif

if dein#tap('caw.vim')
  " C-/ でコメントアウト。ビジュアルモードの時に選択範囲を解除されないようにするmapも追加
  nmap <C-_> <Plug>(caw:i:toggle)
  vmap <C-_> <Plug>(caw:i:toggle)gv
endif

if dein#tap('open-browser.vim')
  " gs でカーソル下のURLをブラウザで開く
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)
endif

if dein#tap('previm')
  " TODO: :PrevimOpen でブラウザを開けるんだがquick-runで開きたい
endif

if dein#tap('syntastic')
  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_check_on_open = 1
  let g:syntastic_check_on_wq = 0
  let g:syntastic_error_symbol='✗'
  let g:syntastic_warning_symbol='⚠'
  let g:syntastic_style_error_symbol = '✗'
  let g:syntastic_style_warning_symbol = '⚠'
  let g:syntastic_debug = 0
  let g:syntastic_debug_file = '~/syntastic.log'
  let g:syntastic_sh_shellcheck_args = '-e SC1008,SC1091'
endif

if dein#tap('neomake')
  let g:neomake_open_list = 1
  " autocmd VimEnter,BufWritePost * Neomake
endif

if dein#tap('vim-markdown')
  let g:vim_markdown_new_list_item_indent = 2
endif

" vim-airline
let g:airline_powerline_fonts=1
" tagbar
nmap <F8> :TagbarToggle<CR>
" auto-ctags
let g:auto_ctags = 1
let g:auto_ctags_directory_list = ['.git', '.svn']
let g:auto_ctags_tags_name = 'tags'
let g:auto_ctags_tags_args = '--tag-relative --recurse --sort=yes'
let g:auto_ctags_filetype_mode = 1






"
" " ファイルタイプ関連
" NeoBundle 'Markdown'
" NeoBundle 'pangloss/vim-javascript'
" NeoBundle 'mxw/vim-jsx'
"
" NeoBundle 'sgur/vim-gf-autoload', {'depends': ['kana/vim-gf-user']}
"
" " 補完の凄いやつ
" NeoBundle 'Shougo/neocomplete'
"   " Disable AutoComplPop.
"   let g:acp_enableAtStartup = 0
"   " Use neocomplete.
"   let g:neocomplete#enable_at_startup = 1
"   " Use smartcase.
"   let g:neocomplete#enable_smart_case = 1
"   " Set minimum syntax keyword length.
"   let g:neocomplete#sources#syntax#min_keyword_length = 3
"   let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
"
"   " Define dictionary.
"   let g:neocomplete#sources#dictionary#dictionaries = {
"       \ 'default' : '',
"       \ 'vimshell' : $HOME.'/.vimshell_hist',
"       \ 'scheme' : $HOME.'/.gosh_completions'
"           \ }
"
"   " Define keyword.
"   if !exists('g:neocomplete#keyword_patterns')
"       let g:neocomplete#keyword_patterns = {}
"   endif
"   let g:neocomplete#keyword_patterns['default'] = '\h\w*'
"
"   " Plugin key-mappings.
"   inoremap <expr><C-g>     neocomplete#undo_completion()
"   inoremap <expr><C-l>     neocomplete#complete_common_string()
"
"   " Recommended key-mappings.
"   " <CR>: close popup and save indent.
"   inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"   function! s:my_cr_function()
"     "return neocomplete#close_popup() . "\<CR>"
"     " For no inserting <CR> key.
"     return pumvisible() ? neocomplete#close_popup() : "\<CR>"
"   endfunction
"   " <TAB>: completion.
"   inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
"   " <C-h>, <BS>: close popup and delete backword char.
"   inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
"   inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
"   inoremap <expr><C-y>  neocomplete#close_popup()
"   inoremap <expr><C-e>  neocomplete#cancel_popup()
"   " Close popup by <Space>.
"   "inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"
"
"   " For cursor moving in insert mode(Not recommended)
"   "inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"   "inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"   "inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"   "inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
"   " Or set this.
"   "let g:neocomplete#enable_cursor_hold_i = 1
"   " Or set this.
"   "let g:neocomplete#enable_insert_char_pre = 1
"
"   " AutoComplPop like behavior.
"   "let g:neocomplete#enable_auto_select = 1
"
"   " Shell like behavior(not recommended).
"   "set completeopt+=longest
"   "let g:neocomplete#enable_auto_select = 1
"   "let g:neocomplete#disable_auto_complete = 1
"   "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"
"
"   " Enable omni completion.
"   autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
"   autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"   autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"   autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
"   autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
"
"   " Enable heavy omni completion.
"   if !exists('g:neocomplete#sources#omni#input_patterns')
"     let g:neocomplete#sources#omni#input_patterns = {}
"   endif
"   "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"   "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"   "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
"
"   " For perlomni.vim setting.
"   " https://github.com/c9s/perlomni.vim
"   let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
"
" "" golang
" " golang関連の設定をいい感じにしてくれる（初めては最初に :GoInstallBinaries を実行する）
" NeoBundle 'fatih/vim-go'
"   "" <C-x><C-o> で関数名とかの補完発動
"   "" :Errors でエラー一覧
"   " mappings
"   au FileType go nmap <Leader>s <Plug>(go-implements)
"   au FileType go nmap <Leader>i <Plug>(go-info)
"   au FileType go nmap <Leader>gd <Plug>(go-doc)
"   au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
"   au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
"   au FileType go nmap <leader>r <Plug>(go-run)
"   au FileType go nmap <leader>b <Plug>(go-build)
"   au FileType go nmap <leader>t <Plug>(go-test)
"   au FileType go nmap <leader>c <Plug>(go-coverage)
"   au FileType go nmap gd <Plug>(go-def)
"   au FileType go nmap <Leader>ds <Plug>(go-def-split)
"   au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
"   au FileType go nmap <Leader>dt <Plug>(go-def-tab)
"   au FileType go nmap <Leader>e <Plug>(go-rename)
"   " Enable hilight
"   let g:go_highlight_functions = 1
"   let g:go_highlight_methods = 1
"   let g:go_highlight_structs = 1
"
" NeoBundle "garyburd/go-explorer"
" if executable("go") && !executable("getool")
"   echo "install getool..."
"   call system("go get -u github.com/garyburd/go-explorer/src/getool")
" endif
"
"
"
" " gitが捗る http://d.hatena.ne.jp/cohama/20130517/1368806202
" NeoBundle 'gregsexton/gitv', {'depends': ['tpope/vim-fugitive']}
"   " gitvバッファ専用設定
"   autocmd FileType gitv call s:my_gitv_settings()
"   function! s:my_gitv_settings()
"     " t でdiffのフォルディングを開閉
"     nnoremap <silent><buffer> t :<C-u>windo call <SID>toggle_git_folding()<CR>1<C-w>w
"     " git操作を簡単にするmap
"     nnoremap <buffer> <Space>rb :<C-u>Git rebase <C-r>=GitvGetCurrentHash()<CR><Space>
"     nnoremap <buffer> <Space>R :<C-u>Git revert <C-r>=GitvGetCurrentHash()<CR><CR>
"     nnoremap <buffer> <Space>h :<C-u>Git cherry-pick <C-r>=GitvGetCurrentHash()<CR><CR>
"     nnoremap <buffer> <Space>rh :<C-u>Git reset --hard <C-r>=GitvGetCurrentHash()<CR>
"   endfunction
"   " gitバッファのフォルディングをトグルする関数
"   autocmd FileType git setlocal nofoldenable foldlevel=0
"   function! s:toggle_git_folding()
"     if &filetype ==# 'git'
"       setlocal foldenable!
"     endif
"   endfunction
"   " gitvバッファでカレント行のハッシュ値を取得する関数
"   function! s:gitv_get_current_hash()
"     return matchstr(getline('.'), '\[\zs.\{7\}\ze\]$')
"   endfunction
"

" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

"-----------------------------------------------------------------------------
" 編集関連
"
"オートインデントする
set autoindent
"コメント行で改行すると次の行もコメントになってしまうのを防止する
autocmd FileType * setlocal formatoptions-=ro
"バイナリ編集(xxd)モード（vim -b での起動、もしくは *.bin で発動します）
augroup BinaryXXD
  autocmd!
  autocmd BufReadPre  *.bin let &binary =1
  autocmd BufReadPost * if &binary | silent %!xxd -g 1
  autocmd BufReadPost * set ft=xxd | endif
  autocmd BufWritePre * if &binary | %!xxd -r | endif
  autocmd BufWritePost * if &binary | silent %!xxd -g 1
  autocmd BufWritePost * set nomod | endif
augroup END
"バックスペースで改行やインデントを削除出来るようにする
set backspace=indent,eol,start

" スペルチェック有効
" set spell
set spelllang+=cjk " 日本語をスペルチェックから外す

" カーソル位置を画面中央に保つ(画面上下10行より先のカーソル移動は画面の方がスクロールする)
set scrolloff=10

"挿入モードでの ESC キーを押した後の待ちを無くす http://bit.ly/IhzWae
let &t_SI .= "\e[?7727h"
let &t_EI .= "\e[?7727l"
inoremap <special> <Esc>O[ <Esc>

" "クリップボードからの貼り付け時に自動インデントを無効にする http://bit.ly/IhAnBe
" if &term =~ '\(xterm\|screen-256color\)'
"   let &t_SI .= "\e[?2004h"
"   let &t_EI .= "\e[?2004l"
"   let &pastetoggle = "\e[201~"
"   function XTermPasteBegin(ret)
"     set paste
"     return a:ret
"   endfunction
"   inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
" endif

"-----------------------------------------------------------------------------
" 検索関連
"
"検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
"検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
"検索時に最後まで行ったら最初に戻る
set wrapscan
"検索文字列入力時に順次対象文字列にヒットさる
set incsearch

"-----------------------------------------------------------------------------
" 装飾関連
"
"シンタックスハイライトを有効にする
syntax on
"編集のままバッファ切り替えができるようにする
set hidden
"行番号を表示しない
set nonumber
"カーソル行の強調表示
set cursorline
"非表示文字をハイライト
scriptencoding utf-8
function! HilightUnnecessaryWhiteSpace()
  " on ColorScheme
  highlight CopipeMissEol ctermbg=52 guibg=red
  highlight TabString ctermbg=52 guibg=red
  highlight ZenkakuSpace ctermbg=52 guibg=red
  " on VimEnter,WinEntercall
  call matchadd("CopipeMissEol", '¬ *$')
  call matchadd("TabString", '\t')
  call matchadd("ZenkakuSpace", '　')
endfunction
autocmd ColorScheme,VimEnter,WinEnter * call HilightUnnecessaryWhiteSpace()
" 非表示文字を見えるようにする
set list listchars=tab:▸\ ,eol:¬

"タブ幅を設定する
set softtabstop=2
set shiftwidth=2
set tabstop=2
set expandtab
"入力中のコマンドをステータスに表示する
set showcmd
"括弧入力時の対応する括弧を表示
set showmatch
"検索結果文字列のハイライトを有効にする
set hlsearch
"ステータスラインを常に表示
" set laststatus=2
"ステータスラインに文字コードと改行文字を表示する
" set statusline=%<%f\ %m%=\ %{&ai?'[>]':''}%m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}\ %l,%c\ %P

"-----------------------------------------------------------------------------
" マウス関連
"
" マウスモード
if 0
  if exists('&mouse')
    set mouse=a
  endif
  " screen対応
  if &term == "screen"
    set ttymouse=xterm2
  endif
endif

"-----------------------------------------------------------------------------
" マップ定義
"
"バッファ移動用キーマップ
" F2: 前のバッファ
" F3: 次のバッファ
" F4: バッファ削除
map <F2> <ESC>:bp<CR>
map <F3> <ESC>:bn<CR>
map <F4> <ESC>:bw<CR>
"表示行単位で行移動する
nnoremap j gj
onoremap j gj
xnoremap j gj
nnoremap k gk
onoremap k gk
xnoremap k gk
nnoremap <Down> gj
onoremap <Down> gj
xnoremap <Down> gj
nnoremap <Up> gk
onoremap <Up> gk
xnoremap <Up> gk
" C-a, C-eで行頭行末に移動する
inoremap <C-a> <ESC>^i
inoremap <C-e> <ESC>$i
"フレームサイズを怠惰に変更する
map <kPlus> <C-W>+
map <kMinus> <C-W>-
"インデント操作後も選択範囲を保つ
vnoremap > >gv
vnoremap < <gv
" Macのクリップボードにコピーする
if s:is_mac
  " 無名レジスタ""の内容をpbcopyに渡す
  nmap <C-c> :call system('pbcopy', getreg('"'))<CR>
  " 選択範囲をyankして、更にヤンク内容が入りたての無名レジスタをpbcopyに渡す
  vmap <C-c> y:call system('pbcopy', getreg('"'))<CR>
endif

" インデントが同じかそれより深い範囲を選択する
function! VisualCurrentIndentBlock()
  let current_indent = indent('.')
  let current_line   = line('.')
  let current_col  = col('.')
  let last_line    = line('$')

  let start_line = current_line
  let end_line = current_line
  while start_line != 1 && ( current_indent <= indent(start_line - 1) || getline(start_line - 1) =~ '^\s*$' )
    let start_line = start_line - 1
  endwhile
  while end_line != last_line && ( current_indent <= indent(end_line + 1) || getline(end_line + 1) =~ '^\s*$' )
    let end_line = end_line + 1
  endwhile

  call cursor(start_line, current_col)
  normal V
  call cursor(end_line, current_col)
endfunction

nnoremap gi :call VisualCurrentIndentBlock()<CR>
onoremap gi :normal gi<CR>
