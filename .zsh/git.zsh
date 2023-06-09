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

alias gpr='hub pull-request'
alias gcl='ghq get --look'
command -v git-number &> /dev/null && alias ga='g number add' || alias ga='g add'
alias gaa='ga --all'
alias gau='git autofixup ${upstream}'
alias gap='ga -p'
alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch -D'
alias gbda='git branch --no-color --merged | command grep -vE "^(\*|\s*(main|master|develop|dev)\s*$)" | command xargs -n 1 git branch -d'
alias gbo='git branch --set-upstream-to=origin/$g(git symbolic-ref --short HEAD) $(git symbolic-ref --short HEAD)'
alias gbu='git branch --set-upstream-to=upstream/$(git symbolic-ref --short HEAD) $(git symbolic-ref --short HEAD)'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'
alias gc='git commit -v'
alias gcs='git commit -s -v'
alias gc!='gc --amend'
alias gac='gaa && gc'
alias gac!='gaa && gc!'
alias gacm='gaa && gcm'
alias gcm='gc -m'
alias gcf='gc --fixup'
alias gcfh='gc --fixup HEAD'
alias gacf='gaa && gc --fixup'
alias gacfh='gaa && gc --fixup HEAD'
alias gco='git checkout'
alias gcom='gco main || gco master'
alias gcob='gco -b'
alias gcop='gco -p'
alias gcp='git cherry-pick'
alias gcpa='gcp --abort'
alias gcpc='gcp --continue'
alias gd='git diff'
alias gds='gd --cached'
alias gf='git fetch --tags'
alias glast="git checkout \$(git last | fzf | awk '{print $1}')"
alias gl='git pull --tags -f --rebase --autostash'
alias glog="git log --graph --pretty='%Cred%h%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(blue)<%an>%Creset' --abbrev-commit"
alias gloga="glog --all"
alias glogp='git log -p'
alias gm='git merge'
alias gma='gm --abort'
alias gp='git push -u'
alias gpf='gp --force-with-lease'
alias gpf!='gp --force'
alias gpff!='git pushall --force'
alias gra='git remote add'
alias grr='git remote remove'
alias grv='git remote -v'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i --autosquash'
alias grbm='git rebase -i main || git rebase -i master'
alias grbom='git rebase -i origin/main || git rebase -i origin/master'
alias gr='git reset'
alias gr!='gr --hard'
alias grh='gr HEAD'
alias grh!='gr! HEAD'
alias garh!='gaa && gr! HEAD'
alias gs='git show --show-signature'
alias gst='git status'
alias gg='git number'
alias gss='gst -sb'
alias gsa='git submodule add'
alias gsu='git submodule update --remote'
alias gsr='git submodule-remove'
alias gx='git annex'
alias gxa='git annex add'
alias gxs='git annex sync'
alias gxg='git annex get'
alias gxd='git annex drop'
alias gxc='git annex copy'
alias fork='hub fork'

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
