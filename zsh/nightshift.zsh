nightshift() {
  case $1 in
    '')
      [[ $(pmset -g batt) == *"Battery Power"* ]] && print "nightshift: warning, on battery"
      sudo pmset -a disablesleep 1 || return
      trap 'trap - INT; sudo pmset -a disablesleep 0; print "nightshift: off"; return 130' INT
      pmset displaysleepnow
      print "nightshift: on"
      print "nightshift: press any key to end"
      while read -rk1; do
        read -rq "?nightshift: end? [y/n] " && break
        print
      done
      trap - INT
      print
      sudo pmset -a disablesleep 0 && print "nightshift: off" ;;
    on)
      [[ $(pmset -g batt) == *"Battery Power"* ]] && print "nightshift: warning, on battery"
      sudo pmset -a disablesleep 1 && pmset displaysleepnow && print "nightshift: on" ;;
    off) sudo pmset -a disablesleep 0 && print "nightshift: off" ;;
    login)
      local out
      out=$(sudo brew services start tailscale 2>&1) || { print -r -- "$out"; print "tailscale: login failed"; return 1; }
      sudo tailscale login --ssh || { print "tailscale: login failed"; return 1; }
      print "tailscale: logged in" ;;
    connect)
      local out
      out=$(sudo brew services start tailscale 2>&1) || { print -r -- "$out"; print "tailscale: connect failed"; return 1; }
      sudo tailscale up --ssh || { print "tailscale: connect failed"; return 1; }
      print "tailscale: connected" ;;
    disconnect)
      sudo tailscale down || { print "tailscale: disconnect failed"; return 1; }
      local out
      out=$(sudo brew services stop tailscale 2>&1) || { print -r -- "$out"; print "tailscale: disconnect failed"; return 1; }
      print "tailscale: disconnected" ;;
    logout)
      sudo tailscale logout || { print "tailscale: logout failed"; return 1; }
      local out
      out=$(sudo brew services stop tailscale 2>&1) || { print -r -- "$out"; print "tailscale: logout failed"; return 1; }
      print "tailscale: logged out" ;;
    check)
      local backend_state
      backend_state="$(tailscale status --json 2>/dev/null | jq -r .BackendState 2>/dev/null || true)"
      if [[ $backend_state == NeedsLogin ]]; then
        nightshift login && nightshift connect
      fi
      if sudo systemsetup -getremotelogin | grep -q ': On'; then
        print "tailscale: remote login is on"
        print "sudo systemsetup -setremotelogin off"
      fi ;;
    status)
      pmset -g | grep -q 'SleepDisabled[[:space:]]*1' && print "nightshift: on" || print "nightshift: off"
      local ts=$(tailscale status --json 2>/dev/null | jq -r .BackendState 2>/dev/null)
      case $ts in
        Running) print "tailscale: connected" ;;
        Stopped|'') print "tailscale: disconnected" ;;
        NeedsLogin) print "tailscale: needs login" ;;
        *) print "tailscale: $ts" ;;
      esac ;;
    *)
      local -a rows=(
        'nightshift'            'on, wait, off'
        'nightshift on'         'sleep disabled, display off'
        'nightshift off'        'sleep enabled'
        'nightshift login'      'log in to tailscale'
        'nightshift logout'     'log out of tailscale, stop service'
        'nightshift connect'    'connect to tailscale'
        'nightshift disconnect' 'disconnect from tailscale'
        'nightshift check'      'log in if needed, warn if remote login is on'
        'nightshift status'     'show sleep and tailscale state'
      )
      print "usage: nightshift [on|off|login|logout|connect|disconnect|check|status]"
      printf '  %-21s  %s\n' "${(@)rows}" ;;
  esac
}
