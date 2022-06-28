export PATH="${PATH}:${HOME}/.krew/bin"

alias k='kubectl'
alias kc='kubectx "$(kubectx | fzf +m --height=10%)"'
alias kn='kubens "$(kubens | fzf +m --height=10%)"'
alias kd='k describe'
alias kd!='kd --all-namespaces'
alias kdp='kd pod'
alias kdel='k delete'
alias ke='k exec -ti'
alias kg='k get'
alias kg!='kg --all-namespaces'
alias kgd='kg deployment'
alias kgd!='kgd --all-namespaces'
alias kgp='kg pod'
alias kgp!='kgp --all-namespaces'
alias kgs='kg service'
alias kgs!='kgs --all-namespaces'
alias kl='kubectl logs -f'
alias khpa='kg! hpa'
alias klogs='stern'
alias koff='kubectl config unset current-context'
alias kga='k get pod --all-namespaces'
alias kgaa='kubectl get all --show-labels'

drain_node() {
	kubectl drain --force --delete-emptydir-data --ignore-daemonsets $(kubectl get nodes -o name | fzf +m -1 -q "$1")
}
_drain_node() { compadd $(kubectl get nodes -o name | fzf +m -1 -q "$1") }
compdef _drain_node drain_node

kcout() {
	while IFS= read -rd: config; do
		[ -f "$config" ] || continue
		sed -i -E '/^\s*(access-token|expires-in|expires-on|refresh-token)/d' "$config"
	done <<< "${KUBECONFIG:-$HOME/.kube/config}:"
	echo "disconnected"
}
