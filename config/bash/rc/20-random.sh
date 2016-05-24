random-zenkaku() {
  local c=${1:-20} i s hira kata al num
  hira="あいうえおかきくけこさしすせそたちつてとなにぬねのやゆよわをんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽゑ"
  kata="アイウエオカキクケコサシスセソタチツテトナニヌネノヤユヨワヲンガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポヱヲ"
  num="０１２３４５６７８９"
  al_s="ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ"
  al_b="ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ"
  al="$al_a$al_b"
  zen="$hira$kata$num$al"
  s="$zen"
  for i in $(seq $c); do
    echo -n "${s:$(($RANDOM % ${#s})):1}"
  done
  echo
}
