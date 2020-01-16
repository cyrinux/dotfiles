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
alias pacl='pacman -Ql'
alias pacdiff='sudo \pacdiff; py3-cmd refresh "external_script pacdiff"'
alias lsp="pacman -Qett --color=always | more"

pac() {
  sudo -E pacman "$@"
  py3status-refresh-pacman
  rehash
}
compdef pac=pacman


pacQ() {
    pacman -Qo `which "$1"`
}

pacs() {
  aur search -n -k NumVotes "$@"
  pacman -Ss "$@"
}

pacs!() {
  aur search -k NumVotes "$@"
  pacman -Ss "$@"
}

aurs() {
      aur sync -ScP "$@"
      post_aur
    }
alias aurs!='aurs --no-ver-shallow -f'

aurb() {
  aur build -Scf --pkgver "$@"
  post_aur
}

auru() {
  xargs -a <(aur vercmp-devel | cut -d: -f1) aur sync -ScPu --rebuild "$@"
  # post_aur
}

post_aur() {
  sudo -E pacman -Sy
  py3status-refresh-pacman
  aur_clean
}

aur_clean() {
  find ~/.cache/aurutils/sync -name .git -execdir git clean -fx \; >/dev/null
  find /var/cache/pacman/cyrinux-aur -name '*~' -delete >/dev/null
  find /var/cache/pacman/cyrinux-aur -group root -delete >/dev/null
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

alias rsyncrepo='rsync --archive --partial --delete --checksum --verbose /var/cache/pacman/cyrinux-aur/* aur@backup-aur:/var/services/homes/cyril/www/aur/'
alias update='auru; pacu'
alias signrepo='repoctl update'

rebuild() {
    aurs! $1 && SNAP_PAC_SKIP=true sudo -E pacman -Sy $1
}
