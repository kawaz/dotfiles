# Mac以外では無視
[[ "${OSTYPE:0:6}" != "darwin" ]] && return

# DOCKER_HOSTを設定する
if type boot2docker >/dev/null 2>&1; then
  export DOCKER_HOST=tcp://$(boot2docker ip 2>/dev/null):2375
fi
