if type -p aws_completer >/dev/null; then
  complete -C "$(type -p aws_completer)" aws
fi
export AWS_DEFAULT_REGION=ap-northeast-1
