alias goprojects='cd $GOPATH/src/github.com/cyrinux/'
alias rg='rg --hidden --follow --smart-case 2>/dev/null'
alias cp='cp -r --reflink=auto'
alias df='pydf'
alias diff='git diff --no-index'
alias diff!='kitty +kitten diff'
alias dragon='dragon-drag-and-drop --and-exit --all'
alias emacsedit="emacsclient -nc -s instance1"
alias e='kak'
alias grep='grep --color'
alias http-serve='python3 -m http.server'
alias locate='locate -i'
alias mkdir='mkdir -p'
alias o='xdg-open'
alias rm='rmtrash -rf'
alias rm!='\rm -rf'
alias sudo='sudo -E '
alias ls="exa --group --git --group-directories-first"
alias ll="ls -l"
alias la="ll -a"
alias lk="ll -s=size"                # Sorted by size
alias lm="ll -s=modified"            # Sorted by modified date
#alias lc="ll --created -s=created"   # Sorted by created date
alias yubikey-unlock='sudo systemctl stop pcscd.service'
alias rg='noglob rg --smart-case --hidden --ignore-file=$HOME/.rgignore'
alias ip="ip -c"
mkdcd() {
  [ -n "$1" ] && mkdir -p "$1" && builtin cd "$1"
}

# Extension based commands
alias -s gz='tar -xzvf'
alias -s tgz='tar -xzvf'
alias -s bz2='tar -xjvf'
alias -s bz2='tar -xjvf'
alias -s pdf='firewarden -c zathura'
alias -s jpg=vimiv
alias -s png=vimiv
alias -s avi='mpv --quiet'
alias -s mkv='mpv --quiet'
alias -s mp4='mpv --quiet'

# Task
alias t='task'
alias ta='task add'
alias tm='task modify'
alias ti='task add due:tomorrow tag:inbox'
alias toa='todoist q "$@"'



########
# Misc #
########

p() {
  if (( $# == 0 )); then
    ping 1.1.1.1
  else
    ping $@
  fi
}

vault!(){
  gocryptfs -extpass "pass gocryptfs-mega" -noprealloc /home/cyril/Seafile/datas/encrypted_gocryptfs ~/Vault
  py3-cmd refresh decrypted_documents
  sleep ${1:-10}m
  fusermount -u ~/Vault
  notify-send 'Vault' 'Unmounted!'
}

vault-share!(){
  gocryptfs -extpass "pass gocryptfs-mega-share" -noprealloc /home/cyril/Seafile/shared_with_maximbaz ~/Vault-Share
  sleep ${1:-10}m
  fusermount -u ~/Vault-Share
  notify-send 'Vault Share' 'Unmounted!'
  py3-cmd refresh decrypted_shared
}

alias lmr='mr --config $HOME/library/src/myrepos.conf --directory=$HOME/library/src/'
alias mtr-report='mtr --report --report-cycles 10 --no-dns'
alias http-serve='python -m http.server'
alias bc='bc -lq'
alias utc='env TZ="UTC" date'
alias apparmor-notify="sudo /usr/bin/aa-notify -p -f /var/log/audit/audit.log --display :0"
alias connect-shure-bt1="connect_a2dp 00:0E:DD:06:24:1C"
alias connect-bose-mini-ii="connect_a2dp 08:DF:1F:A9:9E:EC"
alias connect-aeropex="connect_a2dp 20:74:CF:3B:36:A9"
alias clean_cache_zsh="antigen reset"
alias generate_pins="pwgen -n -r=azertyuiopqsdfghjklmwxcvbn -A 3 10"
alias send="croc send"

# iowaiting
iowaiting() {
    watch -n 1 "(ps aux | awk '\$8 ~ /D/  { print \$0 }')"
}

# ranger session
ranger() {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

# fix
ironkey() {
  sudo ironkey $@
}

# download recursive
website_aspirator() {
  wget --no-check-certificate  -r -np -R "index.html*" $@
}

# screencast
screencasting() {
 screencast -u -v hevc_nvenc -W -w @cyrinux -g optipng -o ~/Movies/Screencasts -t /dev/shm/ -v h264_vaapi -A /dev/dri/renderD128 -1 $@
}

# ffmeg
alias ffmpeg="ffmpeg -hide_banner"

# Dict
def() {
  dict $@ | less
}

# task
alias task="todoist"

# greenbone / openvas docker container account
alias gvm="sudo su - gvm-docker"

# tcpdump all requests made by given process
alias sysdig="sudo sysdig"
alias csysdig="sudo csysdig"
httpdump() { sysdig -s 2000 -A -c echo_fds proc.name=$1; }

# log viewer
alias lnav="lnav -q"

# misc
alias graph="graph-easy --from dot --as boxart --stats"

# ssh
alias cssh="tmux-cssh"
alias sssh="cssh"

# mkdocs wiki
alias mkbs="mkdocs build && mkdocs serve"


# spotify download
spotify-download() {
  sudo docker run --rm -it -v ~/Musics:/Spotify:/music ritiek/spotify-downloader -p "$1"
  sudo docker run --rm -it -v ~/Musics/Spotify:/music ritiek/spotify-downloader -l *.txt
  sudo rm -f ~/Musics/Spotify/*.txt
  sudo chown -R $USER ~/Musics/Spotify
}

# java docker version
alias java10-docker="sudo docker container run --rm -it --cpus 2 --entrypoint bash openjdk:10-jdk"
alias java9-docker="sudo docker container run --rm -it --cpus 2 --entrypoint bash openjdk:9-jdk"
alias java8-docker="sudo docker container run --rm -it --cpus 2 --entrypoint bash openjdk:8-jdk"

# ansible
alias ansible-playbook="ANSIBLE_SSH_EXECUTABLE=/usr/bin/ssh ansible-playbook"

# calendar
alias cal="khal calendar"

# gpg
alias gpg-delete-master-key='gpg-connect-agent "DELETE_KEY 0D13C83ACE0E72759DADA333877F9E38CDDF866E" /bye'
alias gpg-yubikey-change-card='gpg-connect-agent "scd serialno" "learn --force" /bye'
