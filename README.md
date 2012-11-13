### SETUP
とりあえず以下を実行しておけば大体環境が整う。

    git clone https://github.com/kawaz/dotfiles.git ~/.dotfiles
    ~/.dorfiles/bin/setup.sh

+ 欲しいパッケージをインストールする権限が無いときや環境が古く最新バージョンを使いたかったりしたときは必要に応じて```bin/build-*.sh```を実行する。
+ ```bin/setup.sh```実行後に初めてvimを起動すると勝手に```NeoBundleInstall```が始まるようになってるので面食らうかもしれないが最初だけなので我慢。


### bin/setup.shのやること
+ ```env/dest```に必要な物を色々DLしたりする。
+ ```etc/skel/.*```へのシンボリックリンクを```$HOME/.*```に作成する。
+ ```$HOME```に元からのドットファイルがあった場合は、上書き前に```~/dotfiles-backup-日付```なディレクトリに退避してくれる。


### 起動処理メモ
+ ```~/.bashrc```は/etc/bashrcの後に```~/.profile.d/*.sh```と```$DOTFILES_DIR/etc/profile.d/*.sh```と```$DOTFILES_DIR/etc/profile.d/*.sh```にあるスクリプトを全て読み込んでいく。
+ 3箇所のprofile.dスクリプトはそれぞれのディレクトリより先に**ファイル名でソート**した順で読み込まれる。
 + 特に```~/.profile.d/*.sh```は勝手には作成されないが、その環境のみで行いたい設定はここに書いておく。
 + 誰よりも先に読み込みたい設定は場合はファイル名を```00-*.sh```とかに、最後に実行したいものは```99-*.sh```とかにしておけば良い。
+ DOTFILES関連のファイルを探す前に```~/.dotfilesrc```があれば読み込んでくれるので```DOTFILES_DIR=/path/to/dotfiles```とかを書いておけば```~/.dotfiles```以外の場所にcloneして使うことも可能。


### ディレクトリ構成
全体像把握の為の図を以下に示す。

    . (~/.dotfilesにcloneされることを想定してるが~/.dotfilesrcでDOTFILES_DIRを設定して切り替えも可能)
    |-- README.md
    |-- bin
    |   |-- build-*.sh   (自前ビルド用のスクリプト、手順メモも兼ねてる)
    |   |-- functions.sh (共通処理用の小物スクリプト、sourceで読み込んで使う)
    |   `-- setup.sh     (git clone後に実行するべきスクリプト、コレ一発で大体環境が整う)
    |-- etc
    |   |-- profile.d    (.bashrcから読み込まれる初期化スクリプト置き場、何となく用途別に分割してる)
    |   |   |-- 20-keychain.sh
    |   |   |-- 20-nvm.sh
    |   |   |-- 30-cpanm.sh
    |   |   |-- 30-misc.sh
    |   |   |-- 30-tmux.bash_completion.sh
    |   |   `-- README
    |   `-- skel         (bin/setup.shによってHOMEからシンボリックリンクされるドットファイル達)
    |       |-- .bash_profile
    |       |-- .bashrc
    |       |-- .gitconfig
    |       |-- .gitignore
    |       |-- .inputrc
    |       |-- .my.cnf
    |       |-- .tmux.conf
    |       |-- .vim -> ../../env/dest/dot-vim/ (bin/setup.shによって作られるシンボリックリンク)
    |       `-- .vimrc
    `-- env (bin/setup.shによって作成される、追加DL物や環境毎の設定が置かれる場所)
        |-- dest (環境毎の色々な実体置き場)
        |   |-- dot-vim (~/.vimの最終リンク先、.gitignoreを綺麗に保つためにこの場所で管理してる)
        |   |   |-- bundle
        |   |   |   `-- (many dict)
        |   |   `-- :
        |   |-- profile.d (bin/build-*.shの成果物の初期化スクリプト置き場、.bashrcから読み込まれる)
        |   |   |-- 10-git.sh
        |   |   |-- 10-vim.sh
        |   |   `-- :
        |   `-- :
        |-- src (bin/build-*.shで使うソース置き場、ビルド環境)
        `-- tmp (何かしらの中間処理で出来る一時ゴミエリア)


### フォロー＆メンション歓迎
Twitter: [@kawaz](https://twitter.com/kawaz)

