g() {
	if [[ $# > 0 ]]; then
		git $@
	else
		git status
	fi
}

# Create a git.io short URL
gitio() {
	if [ -z "${1}" ] || [ -z "${2}" ]; then
		echo "Usage: \`gitio slug url\`"
		return 1
	fi
	curl -i https://git.io/ -F "url=${2}" -F "code=${1}"
}

alias g='git'
alias gcl='ghq get --look'
alias ga='g add'
alias gaa='ga --all'
alias gap='ga -p'
alias gb='g branch'
alias gba='g branch --all'
alias gbd='g branch -D'
alias gbda='g branch --no-color --merged | command grep -vE "^(\*|\s*(main|master|develop|dev)\s*$)" | command xargs -n 1 g branch -d'
alias gbo='g branch --set-upstream-to=origin/$(g symbolic-ref --short HEAD) $(g symbolic-ref --short HEAD)'
alias gbu='g branch --set-upstream-to=upstream/$(g symbolic-ref --short HEAD) $(g symbolic-ref --short HEAD)'
alias gbsb='g bisect bad'
alias gbsg='g bisect good'
alias gbsr='g bisect reset'
alias gbss='g bisect start'
alias gc='g commit -v'
alias gc!='gc --amend'
alias gac='gaa && gc'
alias gac!='gaa && gc!'
alias gacm='gaa && gcm'
alias gcm='gc -m'
alias gcf='gc --fixup'
alias gcfh='gc --fixup HEAD'
alias gacf='gaa && gc --fixup'
alias gacfh='gaa && gc --fixup HEAD'
alias gco='g checkout'
alias gcom='gco main || gco master'
alias gcob='gco -b'
alias gcop='gco -p'
alias gcp='g cherry-pick'
alias gcpa='gcp --abort'
alias gcpc='gcp --continue'
alias gd='g diff'
alias gds='gd --cached'
alias gf='g fetch --tags'
alias gl='g pull --tags -f --rebase --autostash'
alias glog="g log --graph --pretty='%Cred%h%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(blue)<%an>%Creset' --abbrev-commit"
alias gloga="glog --all"
alias glogp='g log -p'
alias gm='g merge'
alias gma='gm --abort'
alias gp='g push -u'
alias gpf='gp --force-with-lease'
alias gpf!='gp --force'
alias gpff!='g pushall --force'
alias gra='g remote add'
alias grr='g remote remove'
alias grv='g remote -v'
alias grba='g rebase --abort'
alias grbc='g rebase --continue'
alias grbi='g rebase -i'
alias grbm='g rebase -i master'
alias grbom='g rebase -i origin/main'
alias gr='g reset'
alias gr!='gr --hard'
alias grh='gr HEAD'
alias grh!='gr! HEAD'
alias garh!='gaa && gr! HEAD'
alias gs='g show --show-signature'
alias gst='g status'
alias gss='gst -sb'
alias gsa='g submodule add'
alias gsu='g submodule update --remote'
alias gsr='g submodule-remove'
alias gx='git annex'
alias gxa='git annex add'
alias gxs='git annex sync'
alias gxg='git annex get'
alias gxd='git annex drop'
alias gxc='git annex copy'

grf() {
	upstream="$(git remote get-url upstream 2>/dev/null || git remote get-url origin)"
	if [[ $# == 1 ]]; then
		fork=$(echo "$upstream" | awk -v name="$1" -F/ '{print $1"/"$2"/"$3"/"name"/"$5}')
		if [[ "$upstream" == https* ]]; then
			fork=$(echo "$upstream" | awk -v name="$1" -F/ '{ print $1 "/" $2 "/" name "/" $5 }')
		else
			fork=$(echo "$upstream" | awk -v name="$1" -F/ '{ print "https://github.com/" name "/" $2 }')
		fi

		git remote remove "$1" 2>/dev/null
		git remote add "$1" "$fork"
		git fetch "$1"
	else
		myfork=$(echo "$upstream" | awk -v name="$USER_GITHUB" -F/ '{ print "git@github.com:" name "/" $5 }')

		git remote remove upstream 2>/dev/null
		git remote remove origin 2>/dev/null

		git remote add upstream "$upstream"
		git remote add origin "$myfork"

		git fetch upstream
		git fetch origin

		git branch --set-upstream-to=upstream/master master
	fi
}
