if type -p gcloud >/dev/null; then
  . "$(dirname "$(command readlink $(type -p gcloud))")/../completion.bash.inc"
fi
