# Simple calc
calc() {
	local result=""
	result="$(printf "scale=10;%s\\n" "$*" | bc --mathlib | tr -d '\\\n')"
	#						└─ default (when `--mathlib` is used) is 20

	if [[ "$result" == *.* ]]; then
		# improve the output for decimal numbers
		# add "0" for cases like ".5"
		# add "0" for cases like "-.5"
		# remove trailing zeros
		printf "%s" "$result" |
			sed -e 's/^\./0./'  \
			-e 's/^-\./-0./' \
			-e 's/0*$//;s/\.$//'
	else
		printf "%s" "$result"
	fi
	printf "\\n"
}

# Make a temporary directory and enter it
tmpd() {
        local dir
        if [ $# -eq 0 ]; then
                dir=$(mktemp -d)
        else
                dir=$(mktemp -d -t "${1}.XXXXXXXXXX")
        fi
        cd "$dir" || exit
}
# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
targz() {
        local tmpFile="${1%/}.tar"
        tar -cvf "${tmpFile}" --exclude=".DS_Store" "${1}" || return 1
        size=$(
        stat -f"%z" "${tmpFile}" 2> /dev/null; # OS X `stat`
        stat -c"%s" "${tmpFile}" 2> /dev/null # GNU `stat`
        )
        local cmd=""
        if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
                # the .tar file is smaller than 50 MB and Zopfli is available; use it
                cmd="zopfli"
        else
                if hash pigz 2> /dev/null; then
                        cmd="pigz"
                else
                        cmd="gzip"
                fi
        fi
        echo "Compressing .tar using \`${cmd}\`…"
        "${cmd}" -v "${tmpFile}" || return 1
        [ -f "${tmpFile}" ] && rm "${tmpFile}"
        echo "${tmpFile}.gz created successfully."
}
# Determine size of a file or total size of a directory
fs() {
        if du -b /dev/null > /dev/null 2>&1; then
                local arg=-sbh
        else
                local arg=-sh
        fi
        # shellcheck disable=SC2199
        if [[ -n "$@" ]]; then
                du $arg -- "$@"
        else
                du $arg -- .[^.]* *
        fi
}

# Create a data URL from a file
dataurl() {
        local mimeType
        mimeType=$(file -b --mime-type "$1")
        if [[ $mimeType == text/* ]]; then
                mimeType="${mimeType};charset=utf-8"
        fi
        echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}
# Create a git.io short URL
gitio() {
        if [ -z "${1}" ] || [ -z "${2}" ]; then
                echo "Usage: \`gitio slug url\`"
                return 1
        fi
        curl -i https://git.io/ -F "url=${2}" -F "code=${1}"
}

# Run `dig` and display the most useful info
digga() {
        dig +nocmd "$1" +multiline +noall +answer
}

# Query Wikipedia via console over DNS
mwiki() {
        dig +short txt "$*".wp.dg.cx
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

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
tre() {
        tree -aC -I '.git' --dirsfirst "$@" | less -FRNX
}

# get dbus session
dbs() {
        local t=$1
        if [[  -z "$t" ]]; then
                local t="session"
        fi
        dbus-send --$t --dest=org.freedesktop.DBus \
                --type=method_call      --print-reply \
                /org/freedesktop/DBus org.freedesktop.DBus.ListNames
}

# check if uri is up
isup() {
        local uri=$1
        if curl -s --head  --request GET "$uri" | grep "200 OK" > /dev/null ; then
                notify-send --urgency=critical "$uri is down"
        else
                notify-send --urgency=low "$uri is up"
        fi
}

# # Call from a local repo to open the repository on github/bitbucket in browser
# # Modified version of https://github.com/zeke/ghwd
# repo() {
#         # Figure out github repo base URL
#         local base_url
#         base_url=$(git config --get remote.origin.url)
#         base_url=${base_url%\.git} # remove .git from end of string
#         # Fix git@github.com: URLs
#         base_url=${base_url//git@github\.com:/https:\/\/github\.com\/}
#         # Fix git://github.com URLS
#         base_url=${base_url//git:\/\/github\.com/https:\/\/github\.com\/}
#         # Fix git@bitbucket.org: URLs
#         base_url=${base_url//git@bitbucket.org:/https:\/\/bitbucket\.org\/}
#         # Fix git@gitlab.com: URLs
#         base_url=${base_url//git@gitlab\.com:/https:\/\/gitlab\.com\/}
#         # Validate that this folder is a git folder
#         if ! git branch 2>/dev/null 1>&2 ; then
#                 echo "Not a git repo!"
#                 exit $?
#         fi
#         # Find current directory relative to .git parent
#         full_path=$(pwd)
#         git_base_path=$(cd "./$(git rev-parse --show-cdup)" || exit 1; pwd)
#         relative_path=${full_path#$git_base_path} # remove leading git_base_path from working directory
#         # If filename argument is present, append it
#         if [ "$1" ]; then
#                 relative_path="$relative_path/$1"
#         fi
#         # Figure out current git branch
#         # git_where=$(command git symbolic-ref -q HEAD || command git name-rev --name-only --no-undefined --always HEAD) 2>/dev/null
#         git_where=$(command git name-rev --name-only --no-undefined --always HEAD) 2>/dev/null
#         # Remove cruft from branchname
#         branch=${git_where#refs\/heads\/}
#         [[ $base_url == *bitbucket* ]] && tree="src" || tree="tree"
#         url="$base_url/$tree/$branch$relative_path"
#         echo "Calling $(type open) for $url"
#         chromium "$url" &> /dev/null || (echo "Using $(type open) to open URL failed." && exit 1);
# }

# CommandLineFu
cmdfu() {
  curl "http://www.commandlinefu.com/commands/matching/$@/$(echo -n $@ \
    | openssl base64)/plaintext";
}
