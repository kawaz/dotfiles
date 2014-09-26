" https://github.com/Shougo/neobundle.vim
set nocompatible               " be iMproved
filetype off                   " required!
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#rc(expand('~/.vim/bundle/'))

" OS判定
let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_mac = !s:is_windows && !s:is_cygwin && (has('mac') || has('macunix') || has('gui_macvim') || system('uname') =~? '^darwin')

" ファイルタイプ関連
NeoBundle 'jade.vim'
NeoBundle 'coffee.vim'
NeoBundle 'vim-coffee-script'
NeoBundle 'Markdown'
NeoBundle 'jsx/jsx.vim'
NeoBundle 'johnhamelink/blade.vim'
" javascript
NeoBundle 'jiangmiao/simple-javascript-indenter'
  let g:SimpleJsIndenter_BriefMode = 1
NeoBundleLazy 'jelera/vim-javascript-syntax', {'autoload':{'filetypes':['javascript']}}

" フォルディング系
"NeoBundle 'phpfolding.vim'

" %S/// でpreg正規表現を使えるように
NeoBundle 'othree/eregex.vim'

" 複数ファイル名をタブ表示
NeoBundle 'TabBar'
" バイナリ編集が出来るプラグイン
if has('python')
  " Pythonインターフェースに依存するのでチェックが必要
  " http://d.hatena.ne.jp/alwei/20120220/1329756198
  NeoBundle 'https://github.com/Shougo/vinarise'
endif

" 補完の凄いやつ
NeoBundle 'https://github.com/Shougo/neocomplcache.git'
  set completeopt=menuone
  " 起動時に有効化
  let g:neocomplcache_enable_at_startup = 1
  " 補完候補を出すときに、自動的に一番上の候補を選択させしない
  let g:neocomplcache_enable_auto_select = 0
  " シンタックスファイル中で、補完の対象となるキーワードの最小長さを制御
  let g:neocomplcache_min_syntax_length = 3
  " 大文字が入力されるまで大文字小文字の区別を無視する
  let g:neocomplcache_enable_smart_case = 1
  " 補完候補検索時に大文字・小文字を無視する
  let g:neocomplcache_enable_ignore_case = 1
  " 大文字小文字を区切りとしたあいまい検索を行う（DTがDateTimeにマッチする）
  let g:neocomplcache_enable_camel_case_completion = 1
  " アンダーバー区切りのあいまい検索を行う（p_hがpublic_htmlにマッチする）
  let g:neocomplcache_enable_underbar_completion = 1
  " vim標準のキーワード補完を置き換える
  inoremap <expr><C-n> neocomplcache#start_manual_complete()
  inoremap <expr><C-p> neocomplcache#start_manual_complete()
  " カーソル移動時にポップアップが出ないようにする
  inoremap <expr><Up> pumvisible() ? "\<Up>" : neocomplcache#close_popup()."\<Up>"
  inoremap <expr><Down> pumvisible() ? "\<Down>" : neocomplcache#close_popup()."\<Down>"
  inoremap <expr><Left> pumvisible() ? "\<Left>" : neocomplcache#close_popup()."\<Left>"
  inoremap <expr><Right> pumvisible() ? "\<Right>" : neocomplcache#close_popup()."\<Right>"
  " C-h, BSで補完ウィンドウを確実に閉じる
  inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplcache#smart_close_popup()."\<BS>"
  " Tabで補完候補の選択を行う
  inoremap <expr><TAB> pumvisible() ? "\<Down>" : "\<TAB>"
  inoremap <expr><S-TAB> pumvisible() ? "\<Up>" : "\<S-TAB>"
  " C-kでスニペット展開orジャンプ
  imap <C-k> <Plug>(neosnippet_expand_or_jump)
  smap <C-k> <Plug>(neosnippet_expand_or_jump)
  " 改行で補完ウィンドウを閉じる
  inoremap <expr><CR> pumvisible() ? neocomplcache#smart_close_popup() : "\<CR>"
  " スニペット補完が出来るようにする
  NeoBundle 'Shougo/neosnippet.git'
    " スニペット集
    "NeoBundle 'honza/snipmate-snippets.git'
    "let g:neosnippet#snippets_directory='~/.vim/snipmate-snippets/snippets'
    " 自作スニペット置き場
    "let g:neosnippet#snippets_directory.=',~/.dotfiles/vim-snippets'
    " For snippet_complete marker.
    if has('conceal')
      set conceallevel=2 concealcursor=i
    endif
  " オムニ補完設定
  augroup SetOmniCompletionSetting
    autocmd!
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType ctp setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType twig setlocal omnifunc=htmlcomplete#CompleteTags
    "autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
  augroup END
  " 日本語をキャッシュしない
  if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
  endif
  let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
  " 関数を補完するための区切り文字パターン
  if !exists('g:neocomplcache_delimiter_patterns')
    let g:neocomplcache_delimiter_patterns = {}
  endif
  let g:neocomplcache_delimiter_patterns['php'] = ['->', '::', '\']
  "タグ補完の呼び出しパターン
  if !exists('g:neocomplcache_member_prefix_patterns')
    let g:neocomplcache_member_prefix_patterns = {}
  endif
  let g:neocomplcache_member_prefix_patterns['php'] = '->\|::'
  " ディクショナリ定義
  let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'php' : $HOME . '/.vim/dict/php.dict',
    \ 'ctp' : $HOME . '/.vim/dict/php.dict'
    \ }

" \r でファイルを即時実行
NeoBundle 'quickrun.vim'
  if(!exists("g:quickrun_config"))
    let g:quickrun_config = {'*':{'split':''}}
  endif
  let g:quickrun_config.html = {'command' : 'w3m'}
  let g:quickrun_config.jsx = { 'command': 'jsx', 'exec': ['%c --run %s'] }
  if s:is_mac
    let g:quickrun_config.markdown = { 'outputter': 'null', 'command': 'open', 'cmdopt': '-a', 'args': 'Marked', 'exec': '%c %o %a %s' }
  endif
  " 横分割時は下へ､ 縦分割時は右へ新しいウィンドウが開くようにする
  set splitbelow
  set splitright

" ファイル保存時にエラー行があればハイライトする
NeoBundle 'https://github.com/scrooloose/syntastic.git'

" :Ref xxx keyword でマニュアル検索
NeoBundle 'ref.vim'
  let g:ref_phpmanual_path = $HOME . '/.vim/php_manual/php-chunked-xhtml'

" tagsの凄い奴
NeoBundle 'Tagbar'
  nmap <F8> :TagbarToggle<CR>

" gist 編集 http://bit.ly/S1unmW
NeoBundle 'mattn/gist-vim'

" カラースキーマ
NeoBundle 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}

" VimでDBが操作できる vdbi-vim 作った。 http://bit.ly/w1sKPH
NeoBundle 'https://github.com/mattn/vdbi-vim.git'
  " depends on
  NeoBundle 'https://github.com/mattn/webapi-vim.git'

" HTMLの入力がすごくなる c-y, を入力で展開。http://bit.ly/LANuiJ
NeoBundle 'git://github.com/mattn/zencoding-vim.git'

" :BenchVimrc で vimrc の遅い部分を探せる http://bit.ly/wGrX8X
NeoBundle 'git://github.com/mattn/benchvimrc-vim.git'

" ファイル選択が捗る http://bit.ly/NuXA5u
NeoBundle 'https://github.com/kien/ctrlp.vim'
  let g:ctrlp_use_migemo = 1

" gitが捗る http://d.hatena.ne.jp/cohama/20130517/1368806202
NeoBundle 'tpope/vim-fugitive' "依存するもの
NeoBundle 'gregsexton/gitv'
  " gitvバッファ専用設定
  autocmd FileType gitv call s:my_gitv_settings()
  function! s:my_gitv_settings()
    " t でdiffのフォルディングを開閉
    nnoremap <silent><buffer> t :<C-u>windo call <SID>toggle_git_folding()<CR>1<C-w>w
    " git操作を簡単にするmap
    nnoremap <buffer> <Space>rb :<C-u>Git rebase <C-r>=GitvGetCurrentHash()<CR><Space>
    nnoremap <buffer> <Space>R :<C-u>Git revert <C-r>=GitvGetCurrentHash()<CR><CR>
    nnoremap <buffer> <Space>h :<C-u>Git cherry-pick <C-r>=GitvGetCurrentHash()<CR><CR>
    nnoremap <buffer> <Space>rh :<C-u>Git reset --hard <C-r>=GitvGetCurrentHash()<CR>
  endfunction
  " gitバッファのフォルディングをトグルする関数
  autocmd FileType git setlocal nofoldenable foldlevel=0
  function! s:toggle_git_folding()
    if &filetype ==# 'git'
      setlocal foldenable!
    endif
  endfunction
  " gitvバッファでカレント行のハッシュ値を取得する関数
  function! s:gitv_get_current_hash()
    return matchstr(getline('.'), '\[\zs.\{7\}\ze\]$')
  endfunction

" ackで検索が捗る http://bit.ly/PfpjdT
NeoBundle 'https://github.com/mileszs/ack.vim'

" レインボーカラー検索 http://daisuzu.hatenablog.com/entry/2012/12/10/001228
NeoBundle 'daisuzu/rainbowcyclone.vim'
  nmap c/ <Plug>(rc_search_forward)
  nmap c? <Plug>(rc_search_backward)
  nmap c* <Plug>(rc_search_forward_with_cursor)
  nmap c# <Plug>(rc_search_backward_with_cursor)
  nmap cn <Plug>(rc_search_forward_with_last_pattern)
  nmap cN <Plug>(rc_search_backward_with_last_pattern)

filetype plugin indent on " Required!
" NeoBundleInstallがまだだったら実行を促すメッセージを表示(というか勝手に実行してしまえ)
if neobundle#exists_not_installed_bundles()
  echomsg 'Not installed bundles : ' . string(neobundle#get_not_installed_bundle_names())
  "echomsg 'Please execute ":NeoBundleInstall" command.'
  NeoBundleInstall
endif

" カラースキーマの設定はNeoBundleInstallの後に行う
colorscheme Tomorrow-Night

"-----------------------------------------------------------------------------
" 文字コード関連
"
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = 'utf-8,'. &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
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
"環境によりカーソルキーがABCDになってしまう問題対応
set nocompatible
"バックスペースで改行やインデントを削除出来るようにする
set backspace=indent,eol,start
""閉じ括弧や閉じクオートを自動補完(autoindent有効時のみ)
"inoremap <expr> { &ai==1 ? "{}\<LEFT>" : "{"
"inoremap <expr> [ &ai==1 ? "[]\<LEFT>" : "["
"inoremap <expr> ( &ai==1 ? "()\<LEFT>" : "("
"inoremap <expr> " &ai==1 ? "\"\"\<LEFT>" : '"'
"inoremap <expr> ' &ai==1 ? "''\<LEFT>" : "'"
"inoremap <expr> ` &ai==1 ? "``\<LEFT>" : "`"

" カーソル位置を画面中央に保つ(画面上下10行より先のカーソル移動は画面の方がスクロールする)
set scrolloff=10

"挿入モードでの ESC キーを押した後の待ちを無くす http://bit.ly/IhzWae
let &t_SI .= "\e[?7727h"
let &t_EI .= "\e[?7727l"
inoremap <special> <Esc>O[ <Esc>
"クリップボードからの貼り付け時に自動インデントを無効にする http://bit.ly/IhAnBe
if &term =~ '\(xterm\|screen-256color\)'
  let &t_SI .= "\e[?2004h"
  let &t_EI .= "\e[?2004l"
  let &pastetoggle = "\e[201~"
  function XTermPasteBegin(ret)
    set paste
    return a:ret
  endfunction
  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif

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
"選択した文字列を検索(2文字目をゆっくり入力すれば発動しない)
vnoremap <silent> // y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
"選択した文字列を置換(2文字目をゆっくり入力すれば発動しない)
vnoremap :s "xy:%s/<C-R>=escape(@x, '\\/.*$^~[]')<CR>//gc<Left><Left><Left>

"-----------------------------------------------------------------------------
" 装飾関連
"
"シンタックスハイライトを有効にする
if has("syntax")
  syntax on
endif
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
  highlight TabString ctermbg=red guibg=red
  highlight TrailingSpaces cterm=underline ctermbg=red guibg=red
  highlight ZenkakuSpace cterm=underline ctermbg=red guibg=red
  " on VimEnter,WinEnter
  call matchadd("TabString", '\t')
  call matchadd("TrailingSpaces", '\s\+$')
  call matchadd("ZenkakuSpace", '　')
endfunction
autocmd ColorScheme,VimEnter,WinEnter * call HilightUnnecessaryWhiteSpace()
"タブとかを見える化
set list
set listchars=tab:\ \ ,
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
set laststatus=2
"ステータスラインに文字コードと改行文字を表示する
set statusline=%<%f\ %m%=\ %{&ai?'[>]':''}%m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}\ %l,%c\ %P

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
  vmap <C-c> y:call system("pbcopy", getreg("\""))<CR>
  nmap <C-c> :call system("pbcopy", getreg("\""))<CR>
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
