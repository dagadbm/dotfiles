# astrodark theme, derived
# legend: <palette key>: <variables set>
# bold syntax.blue: di, tw, ow, st
# syntax.cyan: ln
# syntax.red: or, mi, archive exts
# syntax.yellow: so, pi, bd, cd, config/data exts
# bold syntax.green: ex
# bold syntax.orange: su, sg
# syntax.purple: image/media exts
# syntax.text: doc exts
# syntax.comment: backup/log exts
() {
  local red='38;2;255;131;139'      # syntax.red
  local orange='38;2;245;152;58'    # syntax.orange
  local yellow='38;2;223;171;37'    # syntax.yellow
  local green='38;2;135;192;95'     # syntax.green
  local cyan='38;2;74;194;184'      # syntax.cyan
  local blue='38;2;94;183;255'      # syntax.blue
  local purple='38;2;221;151;241'   # syntax.purple
  local text='38;2;173;176;187'     # syntax.text
  local comment='38;2;105;108;118'  # syntax.comment

  local -a entries ext
  entries=(
    "no=0" "fi=0"
    "di=1;$blue" "ln=$cyan" "or=$red" "mi=$red"
    "so=$yellow" "pi=$yellow" "bd=$yellow" "cd=$yellow"
    "ex=1;$green" "su=1;$orange" "sg=1;$orange"
    "tw=1;$blue" "ow=1;$blue" "st=1;$blue"
  )
  # archives
  for ext in zip tar gz tgz bz2 xz zst 7z rar jar dmg pkg deb rpm; entries+=("*.$ext=$red")
  # images and media
  for ext in png jpg jpeg gif webp svg ico bmp tiff mp3 flac wav ogg mp4 mkv mov avi webm; entries+=("*.$ext=$purple")
  # docs
  for ext in md txt rst pdf org; entries+=("*.$ext=$text")
  # config and data
  for ext in json yaml yml toml ini conf xml csv; entries+=("*.$ext=$yellow")
  # backups and logs
  for ext in log bak swp tmp lock; entries+=("*.$ext=$comment")

  export LS_COLORS="${(j.:.)entries}"
  # colour zsh completion lists (and fzf-tab entries) with LS_COLORS
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
}
