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

Bundle 'buftabs'
  "バッファタブにパスを省略してファイル名のみ表示する(buftabs.vim)
  let g:buftabs_only_basename=1
  "バッファタブをステータスライン内に表示する
  let g:buftabs_in_statusline=1
  "ステータスラインにbuftagsと一緒に文字コードや改行コードも表示する
  set laststatus=2
  set statusline=%{g:buftabs_list}%=\ %m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}\ %l,%c\ %P

" \r でファイルを即時実行
Bundle 'quickrun.vim'

Bundle 'AutoComplPop'

Bundle 'FuzzyFinder'
  " FuzzyFinderが依存
  Bundle 'L9'

" :Ref xxx keyword でマニュアル検索
Bundle 'ref.vim'
  let g:ref_phpmanual_path = $HOME . '/.vim/phpmanual-cache/php-chunked-xhtml'

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
"set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

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

