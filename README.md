kawaz'z dotfiles

## SETUP
とりあえず以下を実行しておけば大体環境が整う。

```bash
git clone https://github.com/kawaz/dotfiles.git /path/to/dotfiles
```

```bash:~/.bashrcに追記
# 自分しか使わない環境ならコレ
. /path/to/dotfiles/config/bash/bashrc
# 共用サーバの共用ユーザで他の人も利用する環境の場合はコチラ
. /path/to/dotfiles/config/bash/bashrc-delay.sh
```

## 起動処理メモ
- `config/bash/bashrc` は `config/bash/rc*/*.sh` を順番に読み込んでいく
- ローカル環境のみで読み込みたい場合は rc.local か rc.after に置いておく

## 設定適用の遅延について
共用サーバの共用ユーザでほかの人も利用するような環境の場合は bashrc の代わりに、bashrc-delay.sh を読むようにしておく。
自分環境を有効化したい場合は手で `dotfiles-on` を実行すると bashrc の方の読込みが発動する。
または、環境変数 `XMODIFIERS` に `@dotfiles=on` が含まれていると `bashrc-delay.sh` が読み込まれた直後に自動で `dotfiles-on` が実行される。
リモートの共用サーバに自分のPCからログインした時は手で `dotfiles-on` をする必要を無くせるハックです。
