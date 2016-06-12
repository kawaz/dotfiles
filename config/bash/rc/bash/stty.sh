# 不用な端末コマンドを殺す（そもそも邪魔＆他で再利用できるようにするため）
if type -P stty >/dev/null; then
  # 絶対使わない＆邪魔にしかならない start(C-q)/stop(C-s) を殺す
  stty stop undef
  stty start undef
  # Macだと discard なるコマンドが C-o に設定されているが不用なので殺す
  if [[ $OSTYPE == darwin* ]]; then
    stty discard undef
  fi
  # flush(C-o) も使わないので殺す
  stty flush undef
fi
