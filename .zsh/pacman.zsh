#!/usr/bin/env zsh

pac() {
    sudo -E pacman "$@"

    is_removal=0
    while [[ "$1" == -* ]]; do
        [[ "$1" == "-R"* ]] && is_removal=1
        shift
    done
    if (( is_removal )); then
        echo "\nCleaning up AUR repo..."
        repo-remove -s /var/cache/pacman/cyrinux-aur/cyrinux-aur.db.tar "$@"
    fi

    echo "\nCleaning up repo cache..."
    sudo -E paccache -vr -c /var/cache/pacman/pkg -c /var/cache/pacman/cyrinux-aur
    sudo -E paccache -vruk0 -c /var/cache/pacman/pkg -c /var/cache/pacman/cyrinux-aur

    rehash

    systemctl --user start waybar-updates.service
}
command -v pacman &> /dev/null && compdef pac=pacman

alias paci='SNAP_PAC_SKIP=true pac -Sy'
alias paci!='pac -Sy -dd'
alias pacr='SNAP_PAC_SKIP=true pac -Rs'
alias pacr!='pac -Rs -dd'
alias pacf='SNAP_PAC_SKIP=true pac -U'
alias pacF='pacman -F'
alias pacq='pacman -Si'
alias pacl='pacman -Ql'
alias pacdiff='sudo \pacdiff; pkill -RTMIN+1 -x waybar'

pacs() (
    [ $# -lt 1 ] && { >&2 echo "No search term provided"; return 1; }
    tmp=$(mktemp -d)
    trap 'rm -rf $tmp' EXIT
    cd $tmp
    touch pkgs
    sudo -E pacman -Sy

    {
        NO_COLOR=true aur search -n -k NumVotes "$@"
        pacman -Ss "$@"
    } |
    while read -r pkg; do
        read -r desc
        name="${pkg%% *}"
        mkdir -p `dirname "$name"`
        echo "$pkg" >>pkgs
        echo "$desc" >$name
    done
    [ -s pkgs ] || { >&2 echo "No packages found"; return 2; }
    aur_pkgs=()
    repo_pkgs=()
    cat pkgs | fzf --tac --preview-window=wrap --preview='cat {1}; echo; echo; pacman -Si `basename {1}` 2>/dev/null; true' |
    while read -r pkg; do
        title="${pkg%% *}"
        repo="$(dirname "$title")"
        name="$(basename "$title")"
        if [ "$repo" = "aur" ]; then
            aur_pkgs+=("$name")
        else
            repo_pkgs+=("$name")
        fi
    done
    if (( ${#aur_pkgs[@]} )); then
        aur sync -Sc "${aur_pkgs[@]}"
        post_aur
    fi
    SNAP_PAC_SKIP=true pac -Sy "${aur_pkgs[@]}" "${repo_pkgs[@]}"
)

pacu() {
    xargs -a <(aur vercmp-devel | cut -d: -f1) aur sync -Scu --rebuild "$@"
    post_aur
    pac -Syu
}

pacs!() {
    aur search -k NumVotes "$@"
    pacman -Ss "$@"
}

pacQ() {
    pacman -Qo `which "$1"`
}

aurs() {
    aur sync -Sc "$@"
    sudo -E pacman -Sy
    pkill -RTMIN+1 -x waybar
    post_aur
}
alias aurs!='aurs --nover-argv -f'

aurb() {
    aur build -Scf --pkgver "$@"
    sudo -E pacman -Sy
    pkill -RTMIN+1 -x waybar
    post_aur
}

post_aur() {
    find ~/.cache/aurutils/sync -name .git -execdir git clean -fx \; >/dev/null
    find /var/cache/pacman/cyrinux-aur -group root -delete >/dev/null
}

