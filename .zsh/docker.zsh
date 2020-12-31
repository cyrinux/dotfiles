#!/usr/bin/env zsh

# alias docker="sudo \docker"
alias dr="docker run --rm -it"
alias di="docker images | head -n 1 && docker images | tail -n +2 | sort"
alias dps="docker ps -a"
alias drm="docker rm"
alias drmi="docker rmi"
alias drmcd='drm $(dps -q -f status=exited -f status=created)'
alias drmvd='docker volume rm $(docker volume ls -q -f dangling=true)'
alias drmid='drmi $(docker images -q -f dangling=true)'
alias dpurge="drmcd ; drmvd ; drmid ;docker network prune -f"

command -v podman-compose       &> /dev/null    && alias docker-compose='podman-compose'
alias dcd='docker-compose down'
alias dcl='docker-compose logs -f --tail=1000'
alias dclp='docker-compose pull'
alias dcr='dcd; dcu'
alias dcr='docker-compose restart'
alias dcs='dc ps'
alias dc="docker-compose"
alias dcu='docker-compose up'

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

function dockershellhere() {
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/bash -v $(pwd):/${dirname} -w /${dirname} "$@"
}
function dockershellshhere() {
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/sh -v $(pwd):/${dirname} -w /${dirname} "$@"
}

alias drun='docker run -it --network=host --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --shm-size 16G --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v $HOME/dockerx:/dockerx'
