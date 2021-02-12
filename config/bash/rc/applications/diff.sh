# 引数オプションある場合は素の diff 使うがそうでない普段遣いは git diff --no-index を使いたい関数
diff() { if [[ ${[*]%%[^-]*} == *-* ]]; then command diff "$@"; else git diff --no-index "$@"; fi; }
