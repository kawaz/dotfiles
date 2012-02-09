" プラグイン http://vim-scripts.org/vim/scripts.html 
set nocompatible               " be iMproved
filetype off                   " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" required!
Bundle 'gmarik/vundle'

" ファイルタイプ関連
Bundle 'jade.vim'
Bundle 'coffee.vim'
Bundle 'vim-coffee-script'
Bundle 'Markdown'

" フォルディング系
Bundle 'phpfolding.vim'

" 複数ファイル名をタブ表示
Bundle 'TabBar'

"uniteはsudo vimや古いvimで使えないのでifで囲む
if $SUDO_USER == '' && !(v:version < 702)
  Bundle 'unite.vim'
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
Bundle 'quickrun.vim'

" :Ref xxx keyword でマニュアル検索
Bundle 'ref.vim'
  let g:ref_phpmanual_path = $HOME . '/.vim/phpmanual-cache/php-chunked-xhtml'

" tagsの凄い奴
Bundle 'Tagbar'
  nmap <F8> :TagbarToggle<CR>

" C-pとかしなくても勝手に補完が動くようになる
" AutoComplPopは古いvimで動かないのでifで囲む"
if !(v:version < 702)
  Bundle 'AutoComplPop'
    " 言語ごとの保管辞書を読み込む
    autocmd FileType * let g:AutoComplPop_CompleteOption = '.,w,b,u,t,i'
    autocmd FileType php let g:AutoComplPop_CompleteOption = '.,w,b,u,t,k~/.vim/dict/php.dict'
    autocmd FileType perl let g:AutoComplPop_CompleteOption = '.,w,b,u,t,k~/.vim/dict/perl.dict'
    autocmd FileType ruby let g:AutoComplPop_CompleteOption = '.,w,b,u,t,i,k~/.vim/dict/ruby.dict'
    autocmd FileType javascript let g:AutoComplPop_CompleteOption = '.,w,b,u,t,i,k~/.vim/dict/javascript.dict'
    autocmd FileType erlang let g:AutoComplPop_CompleteOption = '.,w,b,u,t,i,k~/.vim/dict/erlang.dict'
    " PHPの辞書とtagsを読み込む
    autocmd FileType php :set dictionary=~/.vim/dict/php.dict
    autocmd FileType php :set tags+=~/.vim/tags/pear.tags
    " 大文字小文字を無視して自動補完
    let g:AutoComplPop_IgnoreCaseOption = 1
endif

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
"閉じ括弧や閉じクオートを自動補完(autoindent有効時のみ)
inoremap <expr> { &ai==1 ? "{}\<LEFT>" : "{"
inoremap <expr> [ &ai==1 ? "[]\<LEFT>" : "["
inoremap <expr> ( &ai==1 ? "()\<LEFT>" : "("
inoremap <expr> " &ai==1 ? "\"\"\<LEFT>" : '"'
inoremap <expr> ' &ai==1 ? "''\<LEFT>" : "'"
inoremap <expr> ` &ai==1 ? "``\<LEFT>" : "`"
"オートインデントを<INSERT>でトグルする
nnoremap <expr> <INSERT> ToggleAutoIndent()
function! ToggleAutoIndent()
  if &autoindent
    set noautoindent
  else
    set autoindent
  endif
endfunction
"補完ウィンドウ表示中、Enterで補完キャンセル＆改行する
inoremap <expr> <CR> pumvisible() ? "\<C-E>\<CR>" : "\<CR>"
"補完ウィンドウ表示中、Tabで補完決定にする
inoremap <expr> <TAB> pumvisible() ? "\<C-Y>" : "\<TAB>"
"補完ウィンドウ表示中、ESCで補完キャンセル＆ノーマルモードにする
inoremap <expr> <ESC> pumvisible() ? "\<C-E>\<ESC>" : "\<ESC>"

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

