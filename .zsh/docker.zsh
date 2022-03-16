# !/usr/bin/env zsh

alias dockertop="ctop"
alias dr="docker run --rm -it"
alias di="docker images | head -n 1 && docker images | tail -n +2 | sort"
alias dps="docker ps -a"
alias drm="docker rm"
alias drmi="docker rmi"
alias drmcd='drm $(dps -q -f status=exited -f status=created)'
alias drmvd='docker volume rm $(docker volume ls -q -f dangling=true)'
alias drmid='drmi $(docker images -q -f dangling=true)'
alias dpurge="drmcd ; drmvd ; drmid ;docker network prune -f"

command -v podman-compose &>/dev/null && alias docker-compose='podman-compose'
alias dc="docker-compose"
alias dcd='dc down'
alias dcl='dc logs -t -f --tail=1000'
alias dclp='dc pull'
alias dcr='dcd; dcu'
alias dce='dc exec'
alias dcr='dc restart'
alias dcs='dc ps'
alias dcu='dc up'
alias dcudb='dcu -d --build'

alias fedora="pod fedora:latest"
alias ubuntu="pod ubuntu:latest"
alias centos="pod centos:latest"
alias centos7="pod centos:7"
alias trusty="pod ubuntu:trusty"
alias xenial="pod ubuntu:xenial"
alias bionic="pod ubuntu:bionic"
alias focal="pod ubuntu:focal"
alias alpine="pod alpine sh"

alias archlinux-docker="pod -it --cpus 2 -v $(pwd):/data -w /data --entrypoint bash archlinux"
alias java10-docker="pod --cpus 2 --entrypoint bash openjdk:10-jdk"
alias java9-docker="pod --cpus 2 --entrypoint bash openjdk:9-jdk"
alias java8-docker="pod --cpus 2 --entrypoint bash openjdk:8-jdk"
alias javaws="xhost +'local:docker@'; docker run -ti --net=host --rm -e DISPLAY=\$DISPLAY -e HOSTNAME=\$HOSTNAME -v \$(pwd):/data -v /tmp/.X11-unix:/tmp/.X11-unix xnaveira/docker-javaws bash"
alias android-build="podman run --rm -v \"$(pwd):/project\" mingc/android-build-box bash -c 'cd /project; ./gradlew assembleDebug'"
alias workspace='docker run --rm -it rwxrob/workspace -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/Seafile/notes/zet:/zet'

function dockershellhere() {
	dirname=${PWD##*/}
	podman run --rm -it --entrypoint=/bin/bash -v $(pwd):/${dirname} -w /${dirname} "$@"
}

function dockershellshhere() {
	dirname=${PWD##*/}
	podman run --rm -it --entrypoint=/bin/sh -v $(pwd):/${dirname} -w /${dirname} "$@"
}

function vagrant() {
	podman run -it --rm \
		-e LIBVIRT_DEFAULT_URI \
		-v /var/run/libvirt/:/var/run/libvirt/ \
		-v ~/.vagrant.d/boxes:/vagrant/boxes \
		-v ~/.vagrant.d/data:/vagrant/data \
		-v ~/.vagrant.d/tmp:/vagrant/tmp \
		-v $(realpath "${PWD}"):${PWD} \
		-v /etc/hosts:/etc/hosts \
		-w $(realpath "${PWD}") \
		--network host \
		--entrypoint /bin/bash \
		--security-opt label=disable \
		docker.io/vagrantlibvirt/vagrant-libvirt:latest \
		vagrant $@
}

alias mk='minikube'
