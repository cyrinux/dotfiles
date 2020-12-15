#!/usr/bin/env zsh

command -v bat       &> /dev/null    && alias c='bat -p'                                           || alias c='cat'
command -v bat       &> /dev/null    && alias c='/usr/bin/bat -p'                                           || alias c='cat'
command -v exa       &> /dev/null    && alias la='ll -a'                                           || alias la='ll -A'
command -v exa       &> /dev/null    && alias lk='ll -s=size'                                      || alias lk='ll -r --sort=size'
command -v exa       &> /dev/null    && alias lm='ll -s=modified'                                  || alias lm='ll -r --sort=time'
command -v exa       &> /dev/null    && alias ls='exa -ga --group-directories-first --time-style=long-iso --color-scale'     || alias ls='ls --color=auto --group-directories-first -h'
command -v fd        &> /dev/null    && alias fd='fd --hidden --follow'                            || alias fd='find . -name'
command -v git       &> /dev/null    && alias diff='git diff --no-index'
command -v htop      &> /dev/null    && alias top='htop'
command -v pydf      &> /dev/null    && alias df='pydf'
command -v rg        &> /dev/null    && alias rg='rg --hidden --follow --smart-case 2>/dev/null'   || alias rg='grep --color=auto --exclude-dir=.git -R'
command -v rmtrash   &> /dev/null    && alias rm='rmtrash -rf'

man() (
    command man "$@" || "$1" --help || "$1" -h
)

if [[ -x ~/bin/num-cpus ]]; then
    command -v make  &>/dev/null && alias make='make -j "${_my_num_cpus:-${_my_num_cpus::=$(~/bin/num-cpus)}}"'
    command -v cmake &>/dev/null && alias cmake='cmake -j "${_my_num_cpus:-${_my_num_cpus::=$(~/bin/num-cpus)}}"'
fi

alias lmr='mr --config ~/.config/myrepos.conf'
alias cp='cp -r --reflink=auto'
alias cpucooling="sudo cpupower frequency-set -u 600Mhz"
alias e="$EDITOR"
alias apparmor-notify="sudo /usr/bin/aa-notify -p -f /var/log/audit/audit.log --display :0"
alias battery-full='sudo cctk --PrimaryBattChargeCfg=standard --ValSetupPwd="$(pass personal/bios)"'
alias battery-normal='sudo cctk --PrimaryBattChargeCfg=custom:50-86 --ValSetupPwd="$(pass personal/bios)"'
alias bc='bc -lq'
alias cal="khal calendar"
alias csysdig="sudo csysdig"
alias diff!='kitty +kitten diff'
alias generate_pins="pwgen -n -r=azertyuiopqsdfghjklmwxcvbn -A 3 10"
alias gpg-delete-master-key='gpg-connect-agent "DELETE_KEY 0D13C83ACE0E72759DADA333877F9E38CDDF866E" /bye'
alias gpg-yubikey-change-card='gpg-connect-agent "scd serialno" "learn --force" /bye'
alias grep='grep --color'
alias hexdump='od -A x -t x1z -v'
alias htpasswd='openssl passwd -apr1'
alias httpdump='sysdig -s 2000 -A -c echo_fds proc.name='
alias http-serve='python3 -m http.server'
alias ip='ip -color -brief'
alias ll='ls -l'
alias locate='locate -i'
alias logviewer="lnav -q"
alias mkdir='mkdir -p'
alias mtr-report='mtr --report --report-cycles 10'
alias o='xdg-open'
alias play_cercle="mpv --no-resume-playback --shuffle https://www.youtube.com/channel/UCPKT_csvP72boVX0XrMtagQ/videos"
alias play_techno="mpv --no-resume-playback --shuffle https://www.youtube.com/channel/UCmfF7JZv26UUKyRedViGIlw/videos"
alias play_bloques="mpv --no-resume-playback --shuffle 'https://www.youtube.com/playlist?list=PL5e6ZkQmSoKeA-KmjgHVOTtYZFH7XIfeM'"
alias readallmail="notmuch tag -unread folder:INBOX"
alias rm!='\rm -rf'
alias send="croc --relay6 send"
alias sudo='sudo -E '
alias sysdig="sudo sysdig"
alias tree='LS_COLORS= tree -aC -I .git --dirsfirst'
alias utc='env TZ="UTC" date'
alias yubikey-fix='sudo systemctl stop pcscd.service'
alias zshupdate='z4h update'

e64() { [[ $# == 1 ]] && base64 <<<"$1" || base64 }
d64() { [[ $# == 1 ]] && base64 --decode <<<"$1" || base64 --decode }
iowaiting() { watch -n 1 "(ps aux | awk '\$8 ~ /D/  { print \$0 }')" }


# Make directory and enter it
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

# Make a temporary directory and enter it
tmpd() { cd "$(mktemp -d -t "${1:-tmp}.XXXXXXXXXX")" }

# Run `dig` and display the most useful info
alias d='dig +nocmd +multiline +noall +answer'

# ping test
p() { [ -n "$DOMAIN" ] && ping ${1}.${DOMAIN} || ping "${1:-1.1.1.1}" }

iowaiting() { watch -n 1 "(ps aux | awk '\$8 ~ /D/  { print \$0 }')" }


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
        echo ""; # newline
        local tmp
        tmp=$(echo -e "GET / HTTP/1.0\\nEOT" \
                | openssl s_client -connect "${domain}:443" 2>&1)
        if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
                local certText
                certText=$(echo "${tmp}" \
                        | openssl x509 -text -certopt "no_header, no_serial, no_version, \
                        no_signame, no_validity, no_issuer, no_pubkey, no_sigdump, no_aux")
                echo "Common Name:"
                echo ""; # newline
                echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//"
                echo ""; # newline
                echo "Subject Alternative Name(s):"
                echo ""; # newline
                echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
                        | sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\\n" | tail -n +2
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

