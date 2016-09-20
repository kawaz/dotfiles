# XDG対応＆タブ
alias vim-xdg='VIMINIT='\''let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'\'' vim'
alias vim='vim-xdg -p'
