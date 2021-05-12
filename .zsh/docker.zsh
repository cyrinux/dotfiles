# !/usr/bin/env zsh

alias docker="sudo \docker"
alias kind="sudo \kind"
alias k3d="sudo \k3d"
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

command -v podman-compose &> /dev/null && alias docker-compose='podman-compose'
alias dc="docker-compose"
alias dcd='dc down'
alias dcl='dc logs -t -f --tail=1000'
alias dclp='dc pull'
alias dcr='dcd; dcu'
alias dce='dc exec'
alias dcr='dc restart'
alias dcs='dc ps'
alias dcu='dc up'

alias fedora="docker run -v $(pwd):/data --rm -it fedora:latest"
alias ubuntu="docker run -v $(pwd):/data --rm -it ubuntu:latest"
alias centos="docker run -v $(pwd):/data --rm -it centos:latest"
alias trusty="docker run -v $(pwd):/data --rm -it ubuntu:trusty"
alias xenial="docker run -v $(pwd):/data --rm -it ubuntu:xenial"
alias bionic="docker run -v $(pwd):/data --rm -it ubuntu:bionic"
alias focal="docker run -v $(pwd):/data --rm -it ubuntu:focal"

alias java10-docker="docker container run --rm -it --cpus 2 --entrypoint bash openjdk:10-jdk"
alias java9-docker="docker container run --rm -it --cpus 2 --entrypoint bash openjdk:9-jdk"
alias java8-docker="docker container run --rm -it --cpus 2 --entrypoint bash openjdk:8-jdk"
alias javaws="docker run -ti --net=host --rm -e DISPLAY=\$DISPLAY -e HOSTNAME=\$HOSTNAME -v \$(pwd):/data -v /tmp/.X11-unix:/tmp/.X11-unix xnaveira/docker-javaws bash"
alias android-build="docker run --rm -v \"$(pwd):/project\" mingc/android-build-box bash -c 'cd /project; ./gradlew assembleDebug'"

function dockershellhere() {
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/bash -v $(pwd):/${dirname} -w /${dirname} "$@"
}
function dockershellshhere() {
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/sh -v $(pwd):/${dirname} -w /${dirname} "$@"
}

alias drun='docker run --rm -it --network=host --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --shm-size 16G --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v $HOME/dockerx:/dockerx'

k8sclusterstart() {
    cat << EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
# 3 control plane node and 1 workers
nodes:
- role: control-plane
- role: control-plane
- role: control-plane
- role: worker
EOF
}
