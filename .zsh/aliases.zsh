alias goprojects='cd $GOPATH/src/github.com/cyrinux/'
alias rg='rg --hidden --follow --smart-case 2>/dev/null'
alias cp='cp -r --reflink=auto'
alias df='pydf'
alias diff='git diff --no-index'
alias diff!='kitty +kitten diff'
alias dragon='dragon-drag-and-drop --and-exit --all'
alias e='nvim'
# alias e='kak'
alias grep='grep --color'
alias http-serve='python3 -m http.server'
alias locate='locate -i'
alias mkdir='mkdir -p'
alias o='xdg-open'
alias rm='rmtrash -rf'
alias rm!='\rm -rf'
alias rsync='rsync --verbose --archive --info=progress2 --human-readable --compress --partial'
alias sudo='sudo -E '
alias ls="exa --git --group-directories-first"
alias ll="ls -l"
alias la="ll -a"
alias lk="ll -s=size"                # Sorted by size
alias lm="ll -s=modified"            # Sorted by modified date
alias lc="ll --created -s=created"   # Sorted by created date

# yadm add dotfile
mkrc!() {
	yadm add $1
	yadm encrypt
	yadm add ~/.gitignore
	yadm add ~/.yadm/encrypt
	yadm add ~/.yadm/files.gpg
	yadm commit -am"add $1"
}

mkrc() {
	yadm add $1
	yadm encrypt
	yadm add ~/.gitignore
	yadm add ~/.yadm/encrypt
	yadm add ~/.yadm/files.gpg
	yadm commit
}

alias yubikey-unlock='sudo systemctl stop pcscd.service'
rcpush() {
	PATH='/bin' yadm push $@
}

mkdcd() {
  [ -n "$1" ] && mkdir -p "$1" && builtin cd "$1"
}

# Extension based commands
alias -s gz='tar -xzvf'
alias -s tgz='tar -xzvf'
alias -s bz2='tar -xjvf'
alias -s txt=gvim
alias -s tex=gvim
alias -s pdf=zathura
alias -s png=feh
alias -s jpg=feh

# Task
alias t='task'
alias ta='task add'
alias tm='task modify'
alias ti='task add due:tomorrow tag:inbox'
alias toa='todoist q "$@"'
alias minikube-start='minikube --vm-driver=kvm2 start --insecure-registry localhost:5000 && sleep 5 && minikube dashboard; eval $(minikube docker-env)'
alias minikube-stop='eval $(minikube docker-env -u); minikube stop'
alias update='PATH="/bin" auru -Tcs $KEYID; pacu'
alias syncrepo='gio mount smb://192.168.42.39/web/aur/; gio copy -p  /var/cache/pacman/cyrinux-aur/* smb://nasux/web/aur/'
alias rsyncrepo='rsync --delete /var/cache/pacman/cyrinux-aur/* aur@backup-aur:www/aur/'
alias signrepo='PATH="/usr/bin:/bin" repo-add -k $KEYID -s /var/cache/pacman/cyrinux-aur/cyrinux-aur.db.tar'
alias apparmor-notify="sudo /usr/bin/aa-notify -p -f /var/log/audit/audit.log --display :0"
alias connect-shure-bt1="connect_a2dp 00:0E:DD:06:24:1C"
alias connect-bose-mini-ii="connect_a2dp 08:DF:1F:A9:9E:EC"
alias clean_cache_zsh="antigen reset"
alias generate_pins="pwgen -n -r=azertyuiopqsdfghjklmwxcvbn -A 3 10"

alias ag='noglob ag'
#alias nvim='kak'
# alias vim='kak'
# alias vi='kak'


p() {
	if (( $# == 0 )); then
		ping 1.1.1.1
	else
		ping $@
	fi
}

########
# Misc #
########

vault!(){
  open-vault $1
}

vault-share!(){
  gocryptfs -extpass "pass gocryptfs-mega-share" /home/cyril/Mega-Share ~/Vault-Share
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

iowaiting() {
    watch -n 1 "(ps aux | awk '\$8 ~ /D/  { print \$0 }')"
}

# Vuln scan
scan(){
 sudo docker run --rm -ti menzo/sn1per-docker sniper -o -re -fp -t $1
}

# yadm
alias yst="yadm status"
alias ya="yadm add"
alias yd="yadm diff"
alias yds="yadm diff --staged"
alias yc="yadm commit"
alias yp="yadm push"

# pentest
alias hacklab-start='cd ~/library/src/personal/docker-hacklab && sudo docker-compose up -d'
alias hacklab-bridge-shell='cd ~/library/src/personal/docker-hacklab && sudo docker-compose exec hacklab_bridge /bin/zsh'
alias hacklab-pia-shell='cd ~/library/src/personal/docker-hacklab && sudo docker-compose exec hacklab_pia /bin/zsh'

alias stego-tools='mkdir -p ~/pentest; sudo docker run -it --rm -v $(pwd)/pentest:/data dominicbreuker/stego-toolkit /bin/bash'


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

alias ffmpeg="ffmpeg -hide_banner"
