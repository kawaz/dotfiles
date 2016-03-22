kawaz'z dotfiles

## SETUP
とりあえず以下を実行しておけば大体環境が整う。

```bash
git clone https://github.com/kawaz/dotfiles.git /path/to/dotfiles
echo '. /path/to/dotfiles/etc/simple-env.sh && kawaz-env' >> ~/.bashrc
```

+ 欲しいパッケージをインストールする権限が無いときや環境が古く最新バージョンを使いたかったりしたときは必要に応じて`bash bin/build-*.sh`を実行する。
+ 初めてvimを起動すると勝手に`dein#install()`が始まるようになってるので面食らうかもしれないが最初だけなので我慢。


## 起動処理メモ
- `config/bash/bashrc` は `~/.profile.d/*.sh`と`$DOTFILES_DIR/etc/profile.d/*.sh`と`$DOTFILES_DIR/.env/dest/profile.d/*.sh`にあるスクリプトを全て読み込んでいく。
  - 3箇所のprofile.d配下のスクリプトはそれぞれの**ファイル名でソート**した順で読み込まれる。
  - `~/.profile.d/*.sh` はgit管理外なのでその環境のみで行いたい設定はここに書いておく。
  - 誰よりも先に読み込みたい設定は場合はファイル名を`00-*.sh`とかにしておけば良い。


## ディレクトリ構成
全体像把握の為の図を以下に示す。

    |-- README.md
    |-- bin
    |   |-- build-*.sh   (自前ビルド用のスクリプト、手順メモも兼ねてる)
    |   |-- functions.sh (共通処理用の小物スクリプト、sourceで読み込んで使う)
    |   `-- setup.sh     (deprecated, 古い環境メモとして残しているが削除予定)
    |-- etc
    |   |-- bash_completion.d (config/bash_completion から読み込まれるbashの追加補完スクリプト)
    |   |   |-- npm.sh
    |   |   |-- tmux.sh
    |   |   `-- virsh.sh
    |   `-- profile.d    (config/bashrcから読み込まれる初期化スクリプト置き場、何となく用途別に分割してる)
    |       |-- 00-XDG.sh       ($XDG_CONFIG_HOMEとかの設定を行う。重要なので最初に読み込む)
    |       |-- 20-keychain.sh
    |       |-- 20-nvm.sh
    |       |-- 30-cpanm.sh
    |       |-- 30-misc.sh
    |       |-- 30-tmux.bash_completion.sh
    |       `-- README
    |-- config  ($XDG_CONFIG_HOME で指定されるパス。各種アプリの設定ファイル置き場)
    |-- cache   ($XDG_CACHE_HOME で指定されるパス。各種アプリのキャッシュファイル置き場。いつキャッシュなので消しても良い。)
    |-- local   ($XDG_DATA_HOME で指定されるパス。各種アプリのデータ置き場。消しても構わないが環境ごとにアプリが何か大切なデータを保存してる可能性があるので気をつける)
    `-- .env (bin/setup.shによって作成される、追加DL物や環境毎の設定が置かれる場所)
        |-- dest (環境毎の色々な実体置き場)
        |   |-- .dotfilesrc (bin/setup.shによって作られる、.bashrcから読み込まれDOTFILES_FIRを設定する)
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
