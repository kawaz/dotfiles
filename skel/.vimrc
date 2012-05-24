" https://github.com/Shougo/neobundle.vim
set nocompatible               " be iMproved
filetype off                   " required!
filetype plugin indent off     " required!
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
  call neobundle#rc(expand('~/.vim/bundle/'))
endif

" ファイルタイプ関連
NeoBundle 'jade.vim'
NeoBundle 'coffee.vim'
NeoBundle 'vim-coffee-script'
NeoBundle 'Markdown'

" フォルディング系
NeoBundle 'phpfolding.vim'

" 複数ファイル名をタブ表示
NeoBundle 'TabBar'

" Pythonインターフェースに依存するのでチェック
if has('python')
  " バイナリ編集が出来るプラグイン
  " http://d.hatena.ne.jp/alwei/20120220/1329756198
  NeoBundle 'https://github.com/Shougo/vinarise'
endif

" 補完の凄いやつ
" 設定の参考 http://code-life.net/?p=2308
NeoBundle 'https://github.com/Shougo/neocomplcache.git'
  set completeopt=menuone
  " 起動時に有効化
  let g:neocomplcache_enable_at_startup = 1
  " シンタックスファイル中で、補完の対象となるキーワードの最小長さを制御
  let g:neocomplcache_min_syntax_length = 3
  " 大文字が入力されるまで大文字小文字の区別を無視する
  let g:neocomplcache_enable_smart_case = 1
  " 補完候補を出すときに、自動的に一番上の候補を選択する
  let g:neocomplcache_enable_auto_select = 1
  " 例えば p_h と入力したとき public_html とマッチするようになる
  let g:neocomplcache_enable_underbar_completion = 1
  " ディクショナリ定義
  let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'php' : $HOME . '/.vim/dict/php.dict',
    \ 'ctp' : $HOME . '/.vim/dict/php.dict'
    \ }
                
"uniteはsudo vimや古いvimで使えないのでifで囲む
if $SUDO_USER == '' && !(v:version < 702)
  NeoBundle 'unite.vim'
    "以下の設定は http://www.karakaram.com/vim/unite/#vimrc を参考にした
    "unite prefix key.
    nnoremap [unite] <Nop>
    nmap <Space>f [unite]
    "unite general settings
    "インサートモードで開始
    let g:unite_enable_start_insert = 1
    "最近開いたファイル履歴の保存数
    let g:unite_source_file_mru_limit = 50
    "file_mruの表示フォーマットを指定。空にすると表示スピードが高速化される
    let g:unite_source_file_mru_filename_format = ''
    "現在開いているファイルのディレクトリ下のファイル一覧。
    "開いていない場合はカレントディレクトリ
    nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
    "バッファ一覧
    nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
    "レジスタ一覧
    nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
    "最近使用したファイル一覧
    nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
    "ブックマーク一覧
    nnoremap <silent> [unite]c :<C-u>Unite bookmark<CR>
    "ブックマークに追加
    nnoremap <silent> [unite]a :<C-u>UniteBookmarkAdd<CR>
    "uniteを開いている間のキーマッピング
    autocmd FileType unite call s:unite_my_settings()
    function! s:unite_my_settings()"{{{
      "ESCでuniteを終了
      nmap <buffer> <ESC> <Plug>(unite_exit)
      "入力モードのときjjでノーマルモードに移動
      imap <buffer> jj <Plug>(unite_insert_leave)
      "入力モードのときctrl+wでバックスラッシュも削除
      imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
      "ctrl+jで縦に分割して開く
      nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
      inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
      "ctrl+jで横に分割して開く
      nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
      inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
      "ctrl+oでその場所に開く
      nnoremap <silent> <buffer> <expr> <C-o> unite#do_action('open')
      inoremap <silent> <buffer> <expr> <C-o> unite#do_action('open')
    endfunction"}}}
endif

" \r でファイルを即時実行
NeoBundle 'quickrun.vim'
  if(!exists("g:quickrun_config"))
    let g:quickrun_config = {}
  endif
  let g:quickrun_config.html = {'command' : 'w3m'}

" ファイル保存時にエラー行があればハイライトする
NeoBundle 'https://github.com/scrooloose/syntastic.git'

" :Ref xxx keyword でマニュアル検索
NeoBundle 'ref.vim'
  let g:ref_phpmanual_path = $HOME . '/.vim/phpmanual-cache/php-chunked-xhtml'

" tagsの凄い奴
NeoBundle 'Tagbar'
  nmap <F8> :TagbarToggle<CR>

" カラースキーマ
NeoBundle 'desert256.vim'

" VimでDBが操作できる vdbi-vim 作った。 http://bit.ly/w1sKPH
NeoBundle 'https://github.com/mattn/vdbi-vim.git'
  " depends on
  NeoBundle 'https://github.com/mattn/webapi-vim.git'

" :BenchVimrc で vimrc の遅い部分を探せる http://bit.ly/wGrX8X
NeoBundle 'git://github.com/mattn/benchvimrc-vim.git'


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

"補完ウィンドウ表示中、Enterで補完キャンセル＆改行する
inoremap <expr> <CR> pumvisible() ? "\<C-E>\<CR>" : "\<CR>"
"補完ウィンドウ表示中、Tabで補完決定にする
inoremap <expr> <TAB> pumvisible() ? "\<C-Y>" : "\<TAB>"
"補完ウィンドウ表示中、ESCで補完キャンセル＆ノーマルモードにする
inoremap <expr> <ESC> pumvisible() ? "\<C-E>\<ESC>" : "\<ESC>"

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
"タブの左側にカーソル表示
set listchars=tab:\ \ 
set list
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
" マウスモード有効
if exists('&mouse')
	set mouse=a
endif
" screen対応
if &term == "screen"
	set ttymouse=xterm2
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
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
"フレームサイズを怠惰に変更する
map <kPlus> <C-W>+
map <kMinus> <C-W>-
"インデント操作後も選択範囲を保つ
vnoremap > >gv
vnoremap < <gv



" インデントが同じかそれより深い範囲を選択する
function! VisualCurrentIndentBlock()
    let current_indent = indent('.')
    let current_line   = line('.')
    let current_col    = col('.')
    let last_line      = line('$')

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
