alias aurc='aur talk -bin 5'
alias paci='pac -Sy'
alias ipaci='SNAP_PAC_SKIP=true paci'
alias ipaci!='ipaci -dd'
alias pacr='pac -Rs'
alias ipacr='SNAP_PAC_SKIP=true pacr'
alias pacr!='pacr -dd'
alias ipacr!='ipacr -dd'
alias pacf='pac -U'
alias ipacf='SNAP_PAC_SKIP=true pacf'
alias pacu='pac -Syu'
alias ipacu='SNAP_PAC_SKIP=true pacu'
alias pacq='pacman -Si'
alias pacQ='pacman -Qo'
alias pacl='pacman -Ql'
alias pacdiff='sudo \pacdiff; py3-cmd refresh "external_script pacdiff"'
alias lsp="pacman -Qett --color=always | more"

alias syncrepo='gio mount smb://192.168.43.39/web/aur/; gio copy -p  /var/cache/pacman/cyrinux-aur/* smb://192.168.43.39/web/aur/'
alias rsyncrepo='rsync --archive --compress --partial --delete /var/cache/pacman/cyrinux-aur/ aur@backup-aur:www/aur/'
alias update='PATH="/bin" auru -Tcs; pacu'
alias signrepo='PATH="/usr/bin:/bin" repo-add -s /var/cache/pacman/cyrinux-aur/cyrinux-aur.db.tar'


pac() {
  sudo -E pacman "$@"
  py3status-refresh-pacman
  rehash
}
compdef pac=pacman

pacs() {
  aur search -n -k NumVotes "$@"
  pacman -Ss "$@"
}

pacs!() {
  aur search -k NumVotes "$@"
  pacman -Ss "$@"
}

aurs() {
  PATH="/bin" aur sync -scP "$@"
  post_aur
}

aurs!() {
    aurs --no-ver-shallow -f "$@"
}

rebuild() {
    aurs! $1 && SNAP_PAC_SKIP=true sudo -E pacman -Sy $1
}

aurb() {
  PATH="/bin" aur build -scf --pkgver "$@"
  post_aur
}

auru() {
  PATH="/bin" xargs -a <(aur vercmp-devel | cut -d: -f1) aur sync -scuP --rebuild "$@"
  post_aur
}

post_aur() {
  sudo -E pacman -Sy
  py3status-refresh-pacman
  aur_clean
}

aur_clean() {
  find ~/.cache/aurutils/sync -name .git -execdir git clean -fx \; >/dev/null
  find /var/cache/pacman/cyrinux-aur -name '*~' -delete >/dev/null
}

py3status-refresh-pacman() {
  pacdiff="external_script pacdiff"
  official="external_script checkofficial"
  repo="external_script checkupdates"
  aur="external_script checkupdates_aur"
  vcs="external_script checkupdates_vcs"
  rebuild="external_script checkrebuild"
  py3-cmd refresh "$pacdiff" "$official" "$repo" "$aur" "$vcs" "$rebuild"
}
