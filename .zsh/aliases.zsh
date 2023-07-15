#!/usr/bin/env zsh

iscmd() {
    command -v "$1" > /dev/null
}

iscmd lsd && alias tree='lsd --tree -t -A -I .git' || alias tree='LS_COLORS= tree -aC -I .git --dirsfirst'
iscmd bat && alias c='bat' || alias c='cat'
iscmd lsd && alias la='ll -a' || alias la='ll -A'
iscmd lsd && alias lk='ll -s=size' || alias lk='ll -r --sort=size'
iscmd lsd && alias lm='ll --timesort -r' || alias lm='ll -r --sort=time'
iscmd lsd && alias ls='lsd --color never' || alias ls='ls --color=auto --group-directories-first -h'
iscmd fd && alias fd='fd --hidden --follow' || alias fd='find . -name'
iscmd git && alias diff='git diff --no-index'
iscmd htop && alias top='htop'
iscmd dfrs && alias df='dfrs'
iscmd rg && alias rg='rg --hidden --follow --smart-case 2>/dev/null' || alias rg='grep --color=auto --exclude-dir=.git -R'
iscmd trash-put && alias rm='trash-put'
compdef trash-put=rm
iscmd dog && alias d='dog' || alias d='dig +nocmd +multiline +noall +answer'
iscmd curlie && alias curl='curlie'
iscmd gdu && alias ncdu='gdu'
iscmd lsplug && alias lsusb='lsplug'

man() (
    command man "$@" || "$1" --help || "$1" -h
)

# Udiskie
alias um='udiskie-mount --recursive --options noatime'
alias uu='udiskie-umount'
alias up='um -p "builtin:tty"'

# Misc
alias rsync='rsync -rz --info=FLIST,COPY,DEL,REMOVE,SKIP,SYMSAFE,MISC,NAME,PROGRESS,STATS'
x() { PAGER="less -+F" xplr | IFS= read -r dir && cd -- "${dir:-.}"; }
alias n="nmcli"
alias hex='teehee'
alias btm='\btm --color gruvbox'
alias e="$EDITOR"
alias h="helix"
alias bottom='btm'
alias cp='cp -r --reflink=auto'
alias battery-full='sudo cctk --PrimaryBattChargeCfg=standard --ValSetupPwd="$(pass personal/bios)"'
alias battery-express='sudo cctk --PrimaryBattChargeCfg=Express --ValSetupPwd="$(pass personal/bios)"'
alias battery-normal='sudo cctk --PrimaryBattChargeCfg=custom:50-86 --ValSetupPwd="$(pass personal/bios)"'
alias bc='bc -lq'
alias cal="khal calendar"
alias cali="khal interactive"
alias csysdig="sudo csysdig"
alias diff!='kitty +kitten diff'
alias generate_pins="pwgen -n -r=azertyuiopqsdfghjklmwxcvbn -A 3 10"
alias gpg-delete-master-key='gpg-connect-agent "DELETE_KEY 0D13C83ACE0E72759DADA333877F9E38CDDF866E" /bye'
alias gpg-yubikey-change-card='gpg-connect-agent "scd serialno" "learn --force" /bye'
alias grep='grep --color'
alias hexdump='od -A x -t x1z -v'
alias htpasswd='openssl passwd -apr1' # pragma: allowlist secret
alias httpdump='sysdig -s 2000 -A -c echo_fds proc.name='
alias http-serve='python3 -m http.server'
alias ip='ip -color -brief'
alias ll='ls -l'
alias la='ls -la'
alias logviewer="lnav -q"
alias mkdir='mkdir -p'
alias mtr-report='mtr --report --report-cycles 10'
alias play_cercle="mpv --no-resume-playback --shuffle https://www.youtube.com/channel/UCPKT_csvP72boVX0XrMtagQ/videos"
alias play_techno="mpv --no-resume-playback --shuffle https://www.youtube.com/channel/UCmfF7JZv26UUKyRedViGIlw/videos"
alias play_bloques="mpv --no-resume-playback --shuffle 'https://www.youtube.com/playlist?list=PL5e6ZkQmSoKeA-KmjgHVOTtYZFH7XIfeM'"
alias readallmail="notmuch tag -unread folder:INBOX"
alias rm!='\rm -rf'
alias send="croc --relay6 send"
alias sudo='sudo -E '
alias sysdig="sudo sysdig"
alias utc='env TZ="UTC" date'
alias yubikey-fix='sudo systemctl stop pcscd.service'
alias zshupdate='z4h update'
alias o=xdg-open

e64() { [[ $# == 1 ]] && base64 <<< "$1" || base64; }
d64() { [[ $# == 1 ]] && base64 --decode <<< "$1" || base64 --decode; }
qr() { [[ $# == 1 ]] && qrencode -t utf8 <<< "$1" || qrencode -t utf8; }
iowaiting() { watch -n 1 "(ps aux | awk '\$8 ~ /D/  { print \$0 }')"; }

# Make directory and enter it
md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1"; }
compdef _directories md

# Make a temporary directory and enter it
tmpd() { cd "$(mktemp -d -t "${1:-tmp}.XXXXXXXXXX")"; }

# ping test
p() { [ -n "$DOMAIN" ] && ping ${1}.${DOMAIN} || ping "${1:-8.8.8.8}"; }

iowaiting() { watch -n 1 "(ps aux | awk '\$8 ~ /D/  { print \$0 }')"; }

# Create a data URL from a file
dataurl() {
    local mimeType
    mimeType=$(file -b --mime-type "$1")
    if [[ $mimeType == text/* ]]; then
        mimeType="${mimeType};charset=utf-8"
    fi
    echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
getcertnames() {
    if [ -z "${1}" ]; then
        echo "ERROR: No domain specified."
        return 1
    fi
    local domain="${1}"
    echo "Testing ${domain}…"
    echo "" # newline
    local tmp
    tmp=$(echo -e "GET / HTTP/1.0\\nEOT" |
        openssl s_client -connect "${domain}:443" 2>&1)
    if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
        local certText
        certText=$(echo "${tmp}" |
            openssl x509 -text -certopt "no_header, no_serial, no_version, \
                        no_signame, no_validity, no_issuer, no_pubkey, no_sigdump, no_aux")
        echo "Common Name:"
        echo "" # newline
        echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//"
        echo "" # newline
        echo "Subject Alternative Name(s):"
        echo "" # newline
        echo "${certText}" | grep -A 1 "Subject Alternative Name:" |
            sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\\n" | tail -n +2
        return 0
    else
        echo "ERROR: Certificate not found."
        return 1
    fi
}

## systemctl
alias sys='systemctl'
alias sysu='systemctl --user'
alias status='sys status'
alias statusu='sysu status'
alias start='sys start'
alias startu='sysu start'
alias stop='sys stop'
alias stopu='sysu stop'
alias restart='sys restart'
alias restartu='sysu restart'
alias enable='sys enable'
alias enableu='sysu enable'
alias disable='sys disable'
alias disableu='sysu disable'
alias reload='sys daemon-reload'
alias reloadu='sysu daemon-reload'
alias timers='sys list-timers'
alias timersu='sysu list-timers'

alias localversion="asdf direnv local"

alias gob='go build'
alias got='go test'
alias gotv='go test -v'
alias goi='go install'
gov() {
    go test -coverprofile=coverage.out
    go tool cover -html=coverage.out
}

mass-usb-creator() {
    udevadm monitor | while read -r line; do
        key=$(echo $line | sed -n -E 's/^UDEV.*add.*\/block\/(sd[a-z]+) \(block\)$/\1/p')
        [ -n "$key" ] && echo "# USB /dev/$key"
        {
            sudo /bin/cp "$1" "/dev/$key" &
            sync
        }
    done
}

# Disable ASLR in a new shell.
# See https://askubuntu.com/a/507954.
alias unsafeshell='setarch "$(uname -m)" -R /bin/bash'

alias meteo='curl -s wttr.in/paris'

alias tf=terraform

go-release() {
    git tag -s "$(svu --strip-prefix $1)"
    git push --tags
    goreleaser --rm-dist
}

alias cachegrind='valgrind --tool=callgrind --dump-instr=yes --collect-jumps=yes --simulate-cache=yes'

alias pia-login='piactl login <(pass personal/http/privateinternetaccess.com-pactl-login)'

complete -C pomo pomo

alias battery='upower -i /org/freedesktop/UPower/devices/battery_macsmc_battery'
