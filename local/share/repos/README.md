ソースコードは全部このディレクトに置いて作業することにした。

- `$GHQ_ROOT` にこのディレクトリを指定してるので `ghq get REPO_URL` とかで簡単 clone が出来るし
- `C-s` に `ghq list + peco` みたいな関数を割り当ててあるので行きたいソースにすぐ行ける

各種プロダクトの似た構造のディレクトリも集約。
以下のパスもこのディレクトリへの symlink にしています。

- `$XDG_CACHE_HOME/dein/repos`
- `$GOPATH/src`
