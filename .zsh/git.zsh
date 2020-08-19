g() {
    if [[ $# > 0 ]]; then
        git $@
    else
        git status
    fi
}

gcl() {
    git clone --recursive "$@"
    cd -- "${${${@: -1}##*/}%.*}"
}

alias ga='git add'
alias gaa='git add --all'
alias gap='git add -p'

alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch -D'
alias gbda='git branch --no-color --merged | command grep -vE "^(\*|\s*(master|develop|dev)\s*$)" | command xargs -n 1 git branch -d'
alias gbo='git branch --set-upstream-to=origin/$(git symbolic-ref --short HEAD) $(git symbolic-ref --short HEAD)'
alias gbu='git branch --set-upstream-to=upstream/$(git symbolic-ref --short HEAD) $(git symbolic-ref --short HEAD)'

alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'

alias gc='git commit -v'
alias gc!='git commit -v --amend'
alias gcn!='git commit --no-edit --amend'
alias gac='git add --all && git commit -v'
alias gac!='git add --all && git commit -v --amend'
alias gacn!='git add --all && git commit --amend --no-edit'
alias gacm='git add --all && git commit -m'
alias gcm='git commit -m'
alias gcf='git commit --fixup'
alias gcfh='git commit --fixup HEAD'
alias gacf='git add --all && git commit --fixup'
alias gacfh='git add --all && git commit --fixup HEAD'

alias gco='git checkout'
alias gcom='git checkout master'
alias gcob='git checkout -b'
alias gcop='git checkout -p'

alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

alias gd='git diff'
alias gds='git diff --cached'
alias gd!='git difftool -d'
alias gds!='git difftool -d --cached'

alias gf='git fetch --tags'
alias gl='git pull --tags -f --rebase --autostash'

alias glog="git log --graph --pretty='%Cred%h%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(blue)<%an>%Creset' --abbrev-commit"
alias gloga="git log --graph --pretty='%Cred%h%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
alias glogp='git log -p'

alias gm='git merge'
alias gma='git merge --abort'

alias gp='git push -u'
alias gpf='git push --force-with-lease'
alias gpf!='git push --force'

alias gra='git remote add'
alias grr='git remote remove'
alias grv='git remote -v'

alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grbm='git rebase -i master'
alias grbom='git rebase -i origin/master'

alias gr='git reset'
alias gr!='git reset --hard'
alias grh='git reset HEAD'
alias grh!='git reset --hard HEAD'
alias garh!='git add --all && git reset --hard HEAD'

alias gs='git show --show-signature'

alias gss='git status -sb'
alias gst='git status'

alias gsa='git submodule add'
alias gsu='git submodule update --remote'

grf() {
    upstream="$(git remote get-url upstream 2> /dev/null || git remote get-url origin)"
    if [[ $# == 1 ]]; then
        fork=$(echo "$upstream" | awk -v name="$1" -F/ '{print $1"/"$2"/"$3"/"name"/"$5}')
        if [[ "$upstream" == https* ]]; then
            fork=$(echo "$upstream" | awk -v name="$1" -F/ '{ print $1 "/" $2 "/" name "/" $5 }')
        else
            fork=$(echo "$upstream" | awk -v name="$1" -F/ '{ print "https://github.com/" name "/" $2 }')
        fi

        git remote remove "$1" 2> /dev/null
        git remote add "$1" "$fork"
        git fetch "$1"
    else
        myfork=$(echo "$upstream" | awk -v name="$USER_GITHUB" -F/ '{ print "git@github.com:" name "/" $5 }')

        git remote remove upstream 2> /dev/null
        git remote remove origin 2> /dev/null

        git remote add upstream "$upstream"
        git remote add origin "$myfork"

        git fetch upstream
        git fetch origin

        git branch --set-upstream-to=upstream/master master
    fi
}
